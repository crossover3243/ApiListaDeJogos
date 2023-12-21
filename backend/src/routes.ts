import express from 'express';
import GamesController from './controllers/GamesController';


const routes = express.Router();
const  gamesController = new GamesController();

// routes.post('/classes', classesControllers.create);
routes.get('/games', gamesController.Index);
routes.get('/games/:id', gamesController.Show);
routes.post('/games', gamesController.Create);
routes.put('/games/:id', gamesController.Edit);
routes.delete('/games/:id', gamesController.Delete);



export default routes;