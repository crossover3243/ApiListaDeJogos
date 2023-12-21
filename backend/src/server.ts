// import express, { Request, Response } from 'express';

// const app = express();
// const port = process.env.PORT || 3000;

// app.get('/', (req: Request, res: Response) => {
//  res.send('Olá! Bem-vindo(a) à nossa API!');
// });

// app.listen(port, () => {
//  console.log(`Servidor rodando na porta ${port}`);
// });


import express from 'express';
import cors from 'cors';
import routes from './routes';

const app = express();

app.use(cors());
app.use(express.json());
app.use(routes);

app.listen(3333);