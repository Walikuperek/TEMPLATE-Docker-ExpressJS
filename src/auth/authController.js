const jwt = require('jsonwebtoken');
const { AdminPermission, UserPermission } = require('./permission');

const login = (req, res) => {
    const { username, password } = req.body;
    console.log('message');
    // Mock authentication, Users module needs to be added
    if (username === 'admin' && password === 'password') {
        const token = jwt.sign({ username, permissions: new AdminPermission() }, process.env.JWT_SECRET, { expiresIn: '1h' });
        return res.json({ token });
    } else if (username === 'user' && password === 'password') {
        const token = jwt.sign({ username, permissions: new UserPermission() }, process.env.JWT_SECRET, { expiresIn: '1h' });
        return res.json({ token });
    } else {
        return res.status(401).json({ message: 'Invalid credentials' });
    }
};

module.exports = { login };
