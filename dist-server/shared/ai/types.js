/**
 * Shared AI contracts — used by Vercel `/api/chat*` (server) and Vite client.
 * Never put API keys in this module.
 */
/** Thrown by callers so orchestrator can skip remaining models on provider-wide 429. */
export class ProviderRateLimitError extends Error {
    provider;
    constructor(provider, message) {
        super(message);
        this.name = "ProviderRateLimitError";
        this.provider = provider;
    }
}
