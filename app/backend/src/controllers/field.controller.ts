import { Request, Response } from 'express';

const FIELDS = [
    { id: 'nepal-police', name: 'Nepal Police', enabled: true },
    { id: 'nepal-army', name: 'Nepal Army', enabled: false },
    { id: 'apf', name: 'Armed Police Force', enabled: false },
];

const RANKS = {
    'nepal-police': [
        { id: 'asi', name: 'Assistant Sub-Inspector (ASI)', enabled: true },
        { id: 'inspector', name: 'Inspector', enabled: false },
        { id: 'constable', name: 'Constable', enabled: false },
    ],
};

export const getFields = (req: Request, res: Response) => {
    res.json(FIELDS);
};

export const getRanks = (req: Request, res: Response) => {
    const { fieldId } = req.params;
    const ranks = RANKS[fieldId as keyof typeof RANKS] || [];
    res.json(ranks);
};
