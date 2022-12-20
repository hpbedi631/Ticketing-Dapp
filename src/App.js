import './App.css';
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Ticket from './components/ticket';
import PrimaryMarket from './components/primaryMarket';
import SecondaryMarket from './components/secondaryMarket';
import Sell from './components/sell';
import Navigation from './components/navigation';

function App() {
  return (
    <BrowserRouter>
        <Navigation />
        <Routes>
            <Route path="/ticket" element={<Ticket />} />
            <Route path="/primary" element={<PrimaryMarket />} />
            <Route path="/secondary" element={<SecondaryMarket />} />
            <Route path="/sell" element={<Sell />} />
        </Routes>
    </BrowserRouter>
  );
}

export default App;
