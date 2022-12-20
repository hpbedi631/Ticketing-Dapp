import { Link } from "react-router-dom";

function Navigation () {
    return (
        <>
            <h1>Ticketing DApp</h1>
            <div className="div-container">
                <nav className="nav-ul-class">
                    <Link to="/ticket" id="ticket-nav">Ticket</Link>
                </nav>
            </div>
        </>
    );
}

export default Navigation