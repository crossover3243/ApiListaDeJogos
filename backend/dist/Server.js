"use strict";
// import express, { Request, Response } from 'express';
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// const app = express();
// const port = process.env.PORT || 3000;
// app.get('/', (req: Request, res: Response) => {
//  res.send('Olá! Bem-vindo(a) à nossa API!');
// });
// app.listen(port, () => {
//  console.log(`Servidor rodando na porta ${port}`);
// });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const routes_1 = __importDefault(require("./routes"));
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use(routes_1.default);
app.listen(3333);
