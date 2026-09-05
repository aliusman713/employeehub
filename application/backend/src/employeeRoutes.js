const express = require("express");
const pool = require("./db");

const router = express.Router();

// Get all employees
router.get("/", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        e.id,
        e.first_name,
        e.last_name,
        e.email,
        e.designation,
        e.salary,
        e.joining_date,
        d.name AS department
      FROM employees e
      LEFT JOIN departments d
        ON e.department_id = d.id
      ORDER BY e.id;
    `);

    res.json(result.rows);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: "Failed to retrieve employees",
    });
  }
});

// Get employee by ID
router.get("/:id", async (req, res) => {
  try {
    const result = await pool.query(
      `
      SELECT
        e.id,
        e.first_name,
        e.last_name,
        e.email,
        e.designation,
        e.salary,
        e.joining_date,
        d.name AS department
      FROM employees e
      LEFT JOIN departments d
        ON e.department_id = d.id
      WHERE e.id = $1;
      `,
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: "Employee not found",
      });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: "Failed to retrieve employee",
    });
  }
});

// Create employee
router.post("/", async (req, res) => {
  const {
    first_name,
    last_name,
    email,
    department_id,
    designation,
    salary,
    joining_date,
  } = req.body;

  try {
    const result = await pool.query(
      `
      INSERT INTO employees
      (
        first_name,
        last_name,
        email,
        department_id,
        designation,
        salary,
        joining_date
      )
      VALUES ($1,$2,$3,$4,$5,$6,$7)
      RETURNING *;
      `,
      [
        first_name,
        last_name,
        email,
        department_id,
        designation,
        salary,
        joining_date,
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);

    res.status(500).json({
      error: "Failed to create employee",
    });
  }
});

module.exports = router;
