function FindProxyForURL(url, host)
        {
        if (isPlainHostName(host))
                return "DIRECT";
        if (shExpMatch (host, "10.*") || shExpMatch(host, "*.example.com"))
                return "DIRECT";
        return "PROXY 200.200.200.200:3128";
}
