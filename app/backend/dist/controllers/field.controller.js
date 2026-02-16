"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getRanks = exports.getFields = void 0;
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
const getFields = (req, res) => {
    res.json(FIELDS);
};
exports.getFields = getFields;
const getRanks = (req, res) => {
    const { fieldId } = req.params;
    const ranks = RANKS[fieldId] || [];
    res.json(ranks);
};
exports.getRanks = getRanks;
