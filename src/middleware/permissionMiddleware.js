const { Permission } = require('../models/permission');

const authorize = (permission) => {
    return (req, res, next) => {
        if (req.user && req.user.permissions[permission]) {
            next();
        } else {
            res.status(403).json({ message: 'Permission denied' });
        }
    };
};

module.exports = { authorize };
