require("dotenv").config();

const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");

const pool = require("./db");

const app = express();
const employeeRoutes = require("./employeeRoutes");

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan("combined"));

app.get("/api/health", (req, res) => {
  res.status(200).json({
    status: "UP",
    service: "employeehub-backend",
  });
});

app.get("/api/ready", async (req, res) => {
  try {
    await pool.query("SELECT 1");

    res.status(200).json({
      status: "READY",
      database: "CONNECTED",
    });
  } catch (error) {
    console.error(error);

    res.status(503).json({
      status: "NOT_READY",
      database: "UNAVAILABLE",
    });
  }
});

const PORT = process.env.PORT || 5000;
app.use("/api/employees", employeeRoutes);

app.listen(PORT, () => {
  console.log(`EmployeeHub backend running on port ${PORT}`);
});
