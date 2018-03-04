const CONFIG = {
  baseURI: '/flood',
  dbCleanInterval: 1000 * 60 * 60,
  dbPath: '/data/rtorrent/flood/',
  floodServerPort: 3000,
  maxHistoryStates: 30,
  pollInterval: 1000 * 5,
  secret: process.env.FLOOD_SECRET || 'flood',
  scgi: {
    host: 'localhost',
    port: 5000,
    socket: true,
    socketPath: '/tmp/rpc.socket'
  },
  ssl: false
};

module.exports = CONFIG;
