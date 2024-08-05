#!/bin/bash

# Create folders
mkdir -p /src/{controllers,middleware,models,routes}

# Create .env file
touch .env

# Create Dockerfile
touch Dockerfile

# Create package.json and package-lock.json (placeholder)
touch package.json package-lock.json

# Create source files
touch src/index.js
touch src/models/permission.js
touch src/models/productModel.js
touch src/controllers/authController.js
touch src/controllers/productController.js
touch src/middleware/authMiddleware.js
touch src/middleware/permissionMiddleware.js
touch src/routes/authRoutes.js
touch src/routes/productRoutes.js

# Write content to files

# .env
cat <<EOL > .env
PORT=5000
MONGO_URI=mongodb://root:example@mongodb:27017/your_db_name?authSource=admin
JWT_SECRET=your_jwt_secret
EOL

# Dockerfile
cat <<EOL > Dockerfile
# Use Node.js 20 as the base image
FROM node:20

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 5000

# Run the application
CMD ["node", "src/index.js"]
EOL

# package.json
cat <<EOL > package.json
{
  "name": "express-app",
  "version": "1.0.0",
  "description": "A simple ExpressJS application with JWT authentication and CRUD operations.",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js"
  },
  "dependencies": {
    "dotenv": "^10.0.0",
    "express": "^4.17.1",
    "jsonwebtoken": "^8.5.1",
    "mongoose": "^5.10.9"
  }
}
EOL

# src/index.js
cat <<EOL > src/index.js
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes');
const productRoutes = require('./routes/productRoutes');

dotenv.config();

const app = express();

app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);

mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('Could not connect to MongoDB', err));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(\`Server running on port \${PORT}\`);
});
EOL

# src/models/permission.js
cat <<EOL > src/models/permission.js
class Permission {
    constructor(permissions = {}) {
        this.createProduct = permissions.createProduct || false;
        this.readProduct = permissions.readProduct || false;
        this.updateProduct = permissions.updateProduct || false;
        this.deleteProduct = permissions.deleteProduct || false;
    }
}

class AdminPermission extends Permission {
    constructor() {
        super({
            createProduct: true,
            readProduct: true,
            updateProduct: true,
            deleteProduct: true
        });
    }
}

class UserPermission extends Permission {
    constructor() {
        super({
            readProduct: true
        });
    }
}

module.exports = { Permission, AdminPermission, UserPermission };
EOL

# src/models/productModel.js
cat <<EOL > src/models/productModel.js
const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    description: String
});

const Product = mongoose.model('Product', productSchema);

module.exports = Product;
EOL

# src/controllers/authController.js
cat <<EOL > src/controllers/authController.js
const jwt = require('jsonwebtoken');
const { AdminPermission, UserPermission } = require('../models/permission');

const login = (req, res) => {
    const { username, password } = req.body;

    // Mock authentication
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
EOL

# src/controllers/productController.js
cat <<EOL > src/controllers/productController.js
const Product = require('../models/productModel');

const createProduct = async (req, res) => {
    try {
        const product = new Product(req.body);
        await product.save();
        res.status(201).json(product);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

const getProducts = async (req, res) => {
    try {
        const products = await Product.find();
        res.json(products);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const getProductById = async (req, res) => {
    try {
        const product = await Product.findById(req.params.id);
        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }
        res.json(product);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const updateProduct = async (req, res) => {
    try {
        const product = await Product.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }
        res.json(product);
    } catch (error) {
        res.status(400).json({ message: error.message });
    }
};

const deleteProduct = async (req, res) => {
    try {
        const product = await Product.findByIdAndDelete(req.params.id);
        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }
        res.json({ message: 'Product deleted' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = { createProduct, getProducts, getProductById, updateProduct, deleteProduct };
EOL

# src/middleware/authMiddleware.js
cat <<EOL > src/middleware/authMiddleware.js
const jwt = require('jsonwebtoken');

const authenticate = (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) {
        return res.status(401).json({ message: 'Access denied' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
    } catch (error) {
        res.status(400).json({ message: 'Invalid token' });
    }
};

module.exports = { authenticate };
EOL

# src/middleware/permissionMiddleware.js
cat <<EOL > src/middleware/permissionMiddleware.js
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
EOL

# src/routes/authRoutes.js
cat <<EOL > src/routes/authRoutes.js
const express = require('express');
const { login } = require('../controllers/authController');

const router = express.Router();

router.post('/login', login);

module.exports = router;
EOL

# src/routes/productRoutes.js
cat <<EOL > src/routes/productRoutes.js
const express = require('express');
const {
    createProduct,
    getProducts,
    getProductById,
    updateProduct,
    deleteProduct
} = require('../controllers/productController');
const { authenticate } = require('../middleware/authMiddleware');
const { authorize } = require('../middleware/permissionMiddleware');

const router = express.Router();

router.post('/', authenticate, authorize('createProduct'), createProduct);
router.get('/', authenticate, authorize('readProduct'), getProducts);
router.get('/:id', authenticate, authorize('readProduct'), getProductById);
router.put('/:id', authenticate, authorize('updateProduct'), updateProduct);
router.delete('/:id', authenticate, authorize('deleteProduct'), deleteProduct);

module.exports = router;
EOL

echo "Project structure created successfully."
