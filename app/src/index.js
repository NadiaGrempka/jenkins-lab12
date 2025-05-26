const express = require('express');
const app = express();
const __version__ = '1.0.0';

app.get('/api/status', (_, res) => {
    res.json({ status: 'OK', version: __version__ });
});

app.get('/api/data', (_, res) => {
    res.json({ data: [{ id: 1, name: 'foo' }, { id: 2, name: 'bar' }] });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log(`Service listening on port ${port}`);
});

module.exports = app;
