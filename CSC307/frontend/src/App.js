import React, { Component } from 'react'
import Table from './Table'
import Form from './Form'
import axios from 'axios'

const backendurl = 'http://localhost:8080'

class App extends Component {
    state = {
        // Does this need to be here?
        characters: [
        ],
    }

    render() {
        const { characters } = this.state

        return (
            <div className="container">
            <Table characterData={characters} removeCharacter={this.removeCharacter} />
            <Form handleSubmit={this.handleSubmit}/>
            </div>
        )
    }
    removeCharacter = id => {
        const { characters } = this.state

        this.makeDeleteCall(id).then( callResult => {
            if (callResult) {
                this.setState({
                    characters: characters.filter((character, i) => {
                        return character.id !== id
                    })
                })
            }
        })
    }

    handleSubmit = character => {
        this.makePostCall(character).then( callResult => {
            console.log(callResult)
            if (callResult) {
                this.setState({ characters: [...this.state.characters, callResult] });
            }
        });
    }


    componentDidMount() {
        console.log(backendurl + '/users')
        axios.get(backendurl+'/users')
            .then(res => {
                const characters = res.data.users_list;
                this.setState({ characters });
            })
            .catch(function (error) {
                console.log(error);
            });
    }

    makePostCall(character) {
        return axios.post(backendurl + '/users', character)
            .then(function (response) {
                return response.data;
            })
            .catch(function (error) {
                console.log(error);
                return false;
            });
    }
    makeDeleteCall(id){
        return axios.delete(backendurl + '/users/'+ id)
            .then(function (response) {
                return (response.status === 204);
            })
            .catch(function (error) {
                console.log(error);
                return false;
            });
    }
}


export default App
