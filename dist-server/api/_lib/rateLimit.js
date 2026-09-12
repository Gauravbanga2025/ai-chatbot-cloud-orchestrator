const buckets = new Map();
export function allowRequest(key, limit, windowMs) {
    const now = Date.now();
    const existing = buckets.get(key);
    if (!existing || now >= existing.resetAt) {
        buckets.set(key, { count: 1, resetAt: now + windowMs });
        return true;
    }
    if (existing.count >= limit)
        return false;
    existing.count += 1;
    return true;
}
export function clientIp(req) {
    const forwarded = req.headers?.["x-forwarded-for"];
    if (typeof forwarded === "string" && forwarded.length > 0) {
        return forwarded.split(",")[0].trim();
    }
    if (Array.isArray(forwarded) && forwarded[0]) {
        return forwarded[0].split(",")[0].trim();
    }
    return req.socket?.remoteAddress || "unknown";
}
