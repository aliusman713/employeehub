import { useEffect, useState } from "react";
import api from "./services/api";
import "./App.css";

function App() {
  const [employees, setEmployees] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchEmployees = async () => {
      try {
        setLoading(true);
        setError("");

        const response = await api.get("/employees");

        if (Array.isArray(response.data)) {
          setEmployees(response.data);
        } else {
          setEmployees([]);
          setError("Invalid employee data received from API");
        }
      } catch (err) {
        console.error("Failed to load employees:", err);
        setError("Failed to load employees");
      } finally {
        setLoading(false);
      }
    };

    fetchEmployees();
  }, []);

  return (
    <div className="app">
      <header className="app-header">
        <div>
          <h1>EmployeeHub</h1>
          <p>Employee Management Dashboard</p>
        </div>
      </header>

      <main className="app-content">
        <div className="section-header">
          <div>
            <h2>Employees</h2>

            <p className="employee-count">
              {employees.length} employee
              {employees.length !== 1 ? "s" : ""}
            </p>
          </div>
        </div>

        {loading && (
          <div className="status-message">
            <p>Loading employees...</p>
          </div>
        )}

        {error && (
          <div className="error-message">
            <p>{error}</p>
          </div>
        )}

        {!loading && !error && employees.length === 0 && (
          <div className="status-message">
            <p>No employees found.</p>
          </div>
        )}

        {!loading && !error && employees.length > 0 && (
          <div className="table-container">
            <table className="employee-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Employee Name</th>
                  <th>Email</th>
                  <th>Department</th>
                  <th>Position</th>
                  <th>Salary</th>
                  <th>Joining Date</th>
                </tr>
              </thead>

              <tbody>
                {employees.map((employee) => (
                  <tr key={employee.id}>
                    <td>{employee.id}</td>

                    <td className="employee-name">
                      {employee.first_name} {employee.last_name}
                    </td>

                    <td>{employee.email || "N/A"}</td>

                    <td>
                      <span className="department-badge">
                        {employee.department || "N/A"}
                      </span>
                    </td>

                    <td>{employee.designation || "N/A"}</td>

                    <td>
                      {employee.salary
                        ? `INR ${Number(employee.salary).toLocaleString(
                            "en-IN"
                          )}`
                        : "N/A"}
                    </td>

                    <td>
                      {employee.joining_date
                        ? new Date(
                            employee.joining_date
                          ).toLocaleDateString("en-IN")
                        : "N/A"}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </main>
    </div>
  );
}

export default App;
