import { iconClasses, Link } from '@material-ui/core'
import React from 'react'
import '../App.css'
import LuggageIcon from '@material-ui/icons/Luggage';
import NotificationsIcon from '@material-ui/icons/Notifications';
import LanguageIcon from '@material-ui/icons/Language';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import { Avatar, Badge } from '@material-ui/core';
import { useHistory } from 'react-router-dom'

function Header() {

    let history = useHistory()
  
    const eventhandler = async () => {
      history.push(`/trackbags`)
    }
    return (
        <div className='header'>
            <img className="header__icon"
            src="https://uploads-ssl.webflow.com/5ac286bb60db4938a648e594/5acd1a998bad9920b5c7c738_Global%20Aviation%20Logo.png"/>
        
            <div className='header__title'>
                <h1>Safe Flight</h1>
            </div>

            <div className='header__quote'>
                <p> Powered by </p>
                <div className='header__astra'> AstraDB</div>
            </div>

            <div className='header__right'>
                <div className='header__luggage'>
                    <LuggageIcon />
                    <Link onClick={ () => { eventhandler()}}>
                        <h2> Track your Bags </h2>
                    </Link>
                </div> 
                <div className='header__alert'> 
                    <Badge badgeContent={2} color="secondary">
                        <NotificationsIcon />
                    </Badge>
                    <Link>
                        Alerts
                    </Link>    
                </div>
                <div className='header__language'>
                    <LanguageIcon />
                    <ExpandMoreIcon />
                </div>
                <Avatar />
            </div>


        </div>
    )
}

export default Header
