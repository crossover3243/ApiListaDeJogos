"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const GamesController_1 = __importDefault(require("./controllers/GamesController"));
const routes = express_1.default.Router();
const gamesController = new GamesController_1.default();
// routes.post('/classes', classesControllers.create);
routes.get('/games', gamesController.Index);
routes.get('/games/:id', gamesController.Show);
routes.post('/games', gamesController.Create);
routes.put('/games/:id', gamesController.Edit);
routes.delete('/games/:id', gamesController.Delete);
exports.default = routes;
