module.exports = {
  apps: [
    {
      name: "news-api",
      script: "./backend/src/server.js",
      instances: "max",
      exec_mode: "cluster",
      max_memory_restart: "1G",
      error_file: "./logs/error.log",
      out_file: "./logs/out.log",
      log_file: "./logs/combined.log",
      time_format: "YYYY-MM-DD HH:mm:ss Z",
      env: {
        NODE_ENV: "production",
      },
      watch: false,
      ignore_watch: ["node_modules", "logs", "public/temp"],
      merge_logs: true,
      autorestart: true,
      max_restarts: 10,
      min_uptime: "10s",
    },
  ],
};
