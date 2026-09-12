import express from 'express';
import { fileURLToPath } from 'url';
import path from 'path';

const app = express();
const PORT = process.env.PORT || 5000;

app.use(express.json());

// Helper to adapt Vercel function exports to Express route handlers
const wrap = (modulePath) => async (req, res) => {
  try {
    const mod = await import(modulePath);
    const handler = mod.default || mod;
    return await handler(req, res);
  } catch (err) {
    console.error(`Error in ${modulePath}:`, err);
    return res.status(500).json({ error: err.message || 'Internal Server Error' });
  }
};

// Mount API endpoints
app.all('/api/chat', wrap('./dist-server/api/chat.js'));
app.all('/api/chat-providers', wrap('./dist-server/api/chat-providers.js'));
app.all('/api/providers', wrap('./dist-server/api/providers.js'));
app.all('/api/dashboard', wrap('./dist-server/api/dashboard.js'));
app.all('/api/events', wrap('./dist-server/api/events.js'));
app.all('/api/insights', wrap('./dist-server/api/insights.js'));
app.all('/api/monitoring', wrap('./dist-server/api/monitoring.js'));
app.all('/api/usage', wrap('./dist-server/api/usage.js'));

app.get('/healthz', (req, res) => res.send('OK'));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`AI Orchestration Backend running on port ${PORT}`);
});
