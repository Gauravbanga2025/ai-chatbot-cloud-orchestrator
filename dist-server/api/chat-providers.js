import { FALLBACK_ORDER, PROVIDER_META } from "../shared/ai/providers.js";
import { isProviderConfigured } from "../shared/ai/orchestrate.js";
import { allowRequest, clientIp } from "./_lib/rateLimit.js";
export default async function handler(req, res) {
    if (req.method !== "GET") {
        return res.status(405).json({ error: "Method not allowed" });
    }
    const ip = clientIp(req);
    if (!allowRequest(`chat-providers:${ip}`, 60, 60_000)) {
        return res.status(429).json({ error: "Too many requests" });
    }
    const providers = FALLBACK_ORDER.map((name) => {
        const meta = PROVIDER_META[name];
        return {
            name: meta.name,
            displayName: meta.displayName,
            icon: meta.icon,
            available: isProviderConfigured(name),
        };
    });
    return res.status(200).json({ providers });
}
