import React from 'react'
import '../App.css'

function Checkin() {
    return (
        <div className="baggage__tracking__page">
        <br />
        <br />
        <br/>
        <div className='container'>
        <form>
            <div className='section'>
            <div className="form-section">
                <div className="break"></div>
                <div className='section input-section'>
                <label className="bold">Please enter the number of bags at Check-in</label>
                <input
                    className='input'
                    name='baggagetagnumber'
                />
                </div>
            </div>
            </div>	
            <br />
            <br />
            <br />
            <button className="btn">Confirm!</button>
        </form>
        </div>

    </div>
    )
}

export default Checkin
