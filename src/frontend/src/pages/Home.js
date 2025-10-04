import React, { useEffect, useState } from 'react';
import axios from 'axios';

function Home() {
  const [health, setHealth] = useState(null);
  
  useEffect(() => {
    axios.get('/api/health')
      .then(res => setHealth(res.data))
      .catch(err => console.error(err));
  }, []);
  
  return (
    <div className="home">
      <h2>Welcome to E-Commerce Platform</h2>
      <p>Your one-stop shop for everything!</p>
      {health && <p>API Status: {health.status}</p>}
    </div>
  );
}

export default Home;
