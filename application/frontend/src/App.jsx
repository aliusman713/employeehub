import { useEffect, useState } from "react";
import api from "./services/api";
import "./App.css";

function App() {
  const [employees, setEmployees] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    let isMounted = true;

    const fetchEmployees = async () => {
      try {
        const response = await api.get("/employees");

        if (isMounted) {
          setEmployees(response.data);
        }
      } catch (err) {
        console.error("Failed to load employees:", err);

        if (isMounted) {
          setError("Failed to load employees");
        }
      } finally {
        if (isMounted) {
          setLoading(false);
        }
      }
    };

    fetchEmployees();

    return () => {
      isMounted = false;
    };
  }, []);

  return (
    <div className="app">
      <header className="header">
        <h1>EmployeeHub</h1>
        <p>Employee Management Dashboard</p>
      </header>

      <main className="container">
        <section className="employee-section">
          <h2>Employees</h2>

          {loading && <p>Loading employees...</p>}

          {error && <p className="error">{error}</p>}

          {!loading && !error && employees.length === 0 && (
            <p>No employees found.</p>
          )}

          {!loading && !error && employees.length > 0 && (
            <div className="employee-grid">
              {employees.map((employee) => (
                <div className="employee-card" key={employee.id}>
                  <h3>{employee.name}</h3>

                  <p>
                    <strong>Email:</strong> {employee.email}
                  </p>

                  <p>
                    <strong>Department:</strong>{" "}
                    {employee.department || "N/A"}
                  </p>

                  <p>
                    <strong>Position:</strong> {employee.position || "N/A"}
                  </p>
                </div>
              ))}
            </div>
          )}
        </section>
      </main>
    </div>
  );
}

export default App;
