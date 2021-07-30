import React from 'react';
import './App.css';
import { HashRouter, Route, Switch } from 'react-router-dom';
import Header from './components/Header';
import Home from './pages/Home';
import TrackBags from './pages/TrackBags';
import Login from './pages/Login';
import PassengerBags from './pages/PassengerBags';
import Checkin from './pages/Checkin';

function App() {
  return (
    <div className="App">
      {/* JavaScript requires the last page in the path to be declared first under Route */}
      <HashRouter>
          <Header />
        <Switch>
          <Route path= "/checkin" component={Checkin}/>
          <Route path= "/trackbags" component={TrackBags}/>
          <Route path= "/passengerbags" component={PassengerBags}/>
          <Route path= "/login" component={Login}/>
          <Route path= "/" component={Home}/>
        </Switch>
      </HashRouter>
    </div>
  );
}

export default App;
