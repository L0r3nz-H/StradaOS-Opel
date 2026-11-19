package com.stradaos.launcher;

import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import javax.net.ssl.X509TrustManager;

/** Uses platform certificate validation with either the system or bundled root store.
 * Both delegates come from TrustManagerFactory; rejection is propagated and tested.
 * No custom certificate or hostname validation is implemented here.
 */
@android.annotation.SuppressLint("CustomX509TrustManager")
final class CertificateTrust implements X509TrustManager {
    private final X509TrustManager system;
    private final X509TrustManager bundled;

    CertificateTrust(X509TrustManager system, X509TrustManager bundled) {
        if (system == null || bundled == null) throw new IllegalArgumentException("Missing trust store");
        this.system = system;
        this.bundled = bundled;
    }

    // Delegate client authentication exclusively to the system trust manager.
    public void checkClientTrusted(X509Certificate[] chain, String auth) throws CertificateException {
        system.checkClientTrusted(chain, auth);
    }

    // Both delegates are created by TrustManagerFactory. A failed validation must propagate;
    // neither this fallback nor the callers bypass hostname verification. Covered by unit tests.
    public void checkServerTrusted(X509Certificate[] chain, String auth) throws CertificateException {
        try { system.checkServerTrusted(chain, auth); }
        catch (CertificateException rejected) { bundled.checkServerTrusted(chain, auth); }
    }

    public X509Certificate[] getAcceptedIssuers() { return system.getAcceptedIssuers(); }
}
