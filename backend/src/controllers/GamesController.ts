import axios from "axios"
import {Request, response, Response } from "express"
import { Game } from "../interfaces/Game"
export default class GamesController{
    
    
    async Index (request:Request, reponse:Response){
        let games:Game[] = []

        await axios.get ("https://academico.espm.br/testeapi/jogo").then( response => {games = response.data} )

        return reponse.json(games)
    }

    
    async Show (request:Request, reponse:Response){
        const {id} = request.params
        try {
            const response = await axios.get(`https://academico.espm.br/testeapi/jogo/${id}`)
            const game = response.data
            return reponse.json(game)
        } catch (error) {
            return reponse.status(404).json (`Erro ao consultar o jogo por ID:${id}`)
        }
    }


    async Create (request:Request, reponse:Response){
        const {
            nome ,
            descricao ,
            produtora,
            ano,
            idadeMinima 
        } = request.body
        try {
            const game:Game ={
                nome ,
                descricao ,
                produtora,
                ano,
                idadeMinima } 
            const response = await axios.post("https://academico.espm.br/testeapi/jogo", game);
            return reponse.json(response.data)
        } catch (error) {
            console.log(error)
            return reponse.status(400).json (`Erro ao Criar Jogo: ${error}`)
        }
    }


    async Edit(request:Request, reponse:Response){
        const {id} = request.params
        const {
            nome ,
            descricao ,
            produtora,
            ano,
            idadeMinima 
        } = request.body
        try {
            const response = await axios.get(`https://academico.espm.br/testeapi/jogo/${id}`)
            let oldgame = response.data
            
            const game:Game ={
                id: [Number(id)][0],
                nome ,
                descricao ,
                produtora,
                ano,
                idadeMinima }
                oldgame = game 
            const response2 = await axios.put(`https://academico.espm.br/testeapi/jogo`, oldgame);
            return reponse.json(response2.data)
        } catch (error) {
            console.log(error)
            return reponse.status(400).json (`Erro ao Criar Jogo: ${error}`)
        }
    }


    async Delete (request:Request, reponse:Response){
        const {id} = request.params
        try {
            const response = await axios.delete(`https://academico.espm.br/testeapi/jogo/${id}`)
            const game = response.data
            return reponse.json(game)
        } catch (error) {
            return reponse.status(404).json (`Erro ao consultar o jogo por ID:${id}`)
        }
    }

    
}