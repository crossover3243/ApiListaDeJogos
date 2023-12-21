"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const axios_1 = __importDefault(require("axios"));
class GamesController {
    Index(request, reponse) {
        return __awaiter(this, void 0, void 0, function* () {
            let games = [];
            yield axios_1.default.get("https://academico.espm.br/testeapi/jogo").then(response => { games = response.data; });
            return reponse.json(games);
        });
    }
    Show(request, reponse) {
        return __awaiter(this, void 0, void 0, function* () {
            const { id } = request.params;
            try {
                const response = yield axios_1.default.get(`https://academico.espm.br/testeapi/jogo/${id}`);
                const game = response.data;
                return reponse.json(game);
            }
            catch (error) {
                return reponse.status(404).json(`Erro ao consultar o jogo por ID:${id}`);
            }
        });
    }
    Create(request, reponse) {
        return __awaiter(this, void 0, void 0, function* () {
            const { nome, descricao, produtora, ano, idadeMinima } = request.body;
            try {
                const game = {
                    nome,
                    descricao,
                    produtora,
                    ano,
                    idadeMinima
                };
                const response = yield axios_1.default.post("https://academico.espm.br/testeapi/jogo", game);
                return reponse.json(response.data);
            }
            catch (error) {
                console.log(error);
                return reponse.status(400).json(`Erro ao Criar Jogo: ${error}`);
            }
        });
    }
    Edit(request, reponse) {
        return __awaiter(this, void 0, void 0, function* () {
            const { id } = request.params;
            const { nome, descricao, produtora, ano, idadeMinima } = request.body;
            try {
                const response = yield axios_1.default.get(`https://academico.espm.br/testeapi/jogo/${id}`);
                let oldgame = response.data;
                const game = {
                    id: [Number(id)][0],
                    nome,
                    descricao,
                    produtora,
                    ano,
                    idadeMinima
                };
                oldgame = game;
                const response2 = yield axios_1.default.put(`https://academico.espm.br/testeapi/jogo`, oldgame);
                return reponse.json(response2.data);
            }
            catch (error) {
                console.log(error);
                return reponse.status(400).json(`Erro ao Criar Jogo: ${error}`);
            }
        });
    }
    Delete(request, reponse) {
        return __awaiter(this, void 0, void 0, function* () {
            const { id } = request.params;
            try {
                const response = yield axios_1.default.delete(`https://academico.espm.br/testeapi/jogo/${id}`);
                const game = response.data;
                return reponse.json(game);
            }
            catch (error) {
                return reponse.status(404).json(`Erro ao consultar o jogo por ID:${id}`);
            }
        });
    }
}
exports.default = GamesController;
