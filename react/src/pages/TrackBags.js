import React from 'react'
import '../App.css'
import { useHistory } from 'react-router-dom'
import axios from 'axios'
import { useState } from 'react'
import { SettingsBackupRestoreSharp } from '@material-ui/icons'

function TrackBags() {

    let history = useHistory()
    const [baggagetagnumber, setbaggagetagnumber] = useState(null)

    const [bagorgcity, setorgbagcity] = useState(null)
    const [bagdestcity, setdestbagcity] = useState(null)

    const eventhandler = async () => {
        const results = await axios.get(`/.netlify/functions/getBaggageData?baggagetagnumber=${baggagetagnumber}`)
        setorgbagcity(results.data[0]["origin_city"])
        setdestbagcity(results.data[0]["destination_city"])
        // console.log(results.data[0])
    }

    return (


        <div className="baggage__tracking__page">
            <br />
            <h1>Track your bags</h1>
            <br />
            <br />
            <h3>Keep track of your bags from check-in to touchdown using your record locator or bag tag number</h3>
            <div className='container'>
            <form>
                <div className='section'>
                <div className="form-section">
                    <div className="break"></div>
                    <div className='section input-section'>
                    <label className="bold">Baggage Tag Number</label>
                    <input
                        className='input'
                        name='baggagetagnumber'
                        onChange={e => setbaggagetagnumber(e.target.value)}
                    />
                    </div>
                </div>
                </div>	
                <br />
                <br />
                <br />
                <button onClick={ () => { eventhandler()}} className="btn"n>Search</button>
            </form>
            </div>
            <p className="featuredAccountTitle">Org City : <span className="accountSubtitle">{bagorgcity}</span></p>
            <br />
            <p className="featuredAccountTitle">Dest ity : <span className="accountSubtitle">{bagdestcity}</span></p>
        </div>
    )
}

export default TrackBags
