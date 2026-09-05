import { useEffect, useState } from "react";
import api from "./services/api";
import "./App.css";

function App() {
  const [employees, setEmployees] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const loadEmployees = async () => {
    try {
      setLoading(true);
      setError("");

      const response = await api.get("/employees");
      setEmployees(response.data);
    } catch (err) {
      console.error(err);
      setError("Unable to load employees.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadEmployees();
  }, []);

  return (
    <div className="app">
      <header className="header">
        <div>
          <h1>EmployeeHub</h1>
          <p>Employee Management Portal</p>
        </div>

        <button onClick={loadEmployees}>
          Refresh
        </button>
      </header>

      <main className="container">
        <section className="dashboard-card">
          <div className="card-header">
            <div>
              <h2>Employees</h2>
              <p>
                Manage employees across your organization.
              </p>
            </div>

            <span className="employee-count">
              {employees.length} Employees
            </span>
          </div>

          {loading && (
            <div className="message">
              Loading employees...
            </div>
          )}

          {error && (
            <div className="error">
              {error}
            </div>
          )}

          {!loading && !error && (
            <div className="table-container">
              <table>
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Department</th>
                    <th>Designation</th>
                    <th>Salary</th>
                  </tr>
                </thead>

                <tbody>
                  {employees.map((employee) => (
                    <tr key={employee.id}>
                      <td>{employee.id}</td>

                      <td>
                        <strong>
                          {employee.first_name}{" "}
                          {employee.last_name}
                        </strong>
                      </td>

                      <td>{employee.email}</td>

                      <td>
                        <span className="department">
                          {employee.department}
                        </span>
                      </td>

                      <td>{employee.designation}</td>

                      <td>
                        ₹
                        {Number(employee.salary).toLocaleString(
                          "en-IN"
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </section>
      </main>
    </div>
  );
}

export default App;
