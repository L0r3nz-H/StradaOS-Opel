package com.stradaos.launcher;

import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import javax.net.ssl.X509TrustManager;
import org.junit.Test;
import static org.junit.Assert.*;

public class CertificateTrustTest {
    private final X509Certificate[] chain = new X509Certificate[0];

    private static final class Store implements X509TrustManager {
        final boolean accepts;
        int serverCalls, clientCalls;
        X509Certificate[] received;
        String auth;
        Store(boolean accepts) { this.accepts = accepts; }
        public void checkServerTrusted(X509Certificate[] c, String a) throws CertificateException {
            serverCalls++; received = c; auth = a;
            if (!accepts) throw new CertificateException("Untrusted chain");
        }
        public void checkClientTrusted(X509Certificate[] c, String a) throws CertificateException {
            clientCalls++;
            if (!accepts) throw new CertificateException("Untrusted client");
        }
        public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }
    }

    @Test public void systemTrustDoesNotConsultBundledRoots() throws Exception {
        Store system = new Store(true), bundled = new Store(false);
        new CertificateTrust(system, bundled).checkServerTrusted(chain, "RSA");
        assertEquals(1, system.serverCalls);
        assertEquals(0, bundled.serverCalls);
        assertSame(chain, system.received);
        assertEquals("RSA", system.auth);
    }

    @Test public void bundledRootsCanValidateWhenSystemRootsReject() throws Exception {
        Store system = new Store(false), bundled = new Store(true);
        new CertificateTrust(system, bundled).checkServerTrusted(chain, "ECDHE_RSA");
        assertEquals(1, system.serverCalls);
        assertEquals(1, bundled.serverCalls);
        assertSame(chain, bundled.received);
        assertEquals("ECDHE_RSA", bundled.auth);
    }

    @Test(expected = CertificateException.class)
    public void rejectionByBothStoresNeverTrustsServer() throws Exception {
        new CertificateTrust(new Store(false), new Store(false)).checkServerTrusted(chain, "RSA");
    }

    @Test(expected = CertificateException.class)
    public void clientTrustNeverFallsBackToBundledRoots() throws Exception {
        new CertificateTrust(new Store(false), new Store(true)).checkClientTrusted(chain, "RSA");
    }

    @Test(expected = IllegalArgumentException.class)
    public void missingStoreCannotDisableValidation() {
        new CertificateTrust(new Store(true), null);
    }
}
