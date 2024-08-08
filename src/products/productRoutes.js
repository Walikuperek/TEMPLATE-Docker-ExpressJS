const express = require('express');
const {
    createProduct,
    getProducts,
    getProductById,
    updateProduct,
    deleteProduct
} = require('./productController');
const { authenticate } = require('./authMiddleware');
const { authorize } = require('./permissionMiddleware');

const router = express.Router();

router.post('/', authenticate, authorize('createProduct'), createProduct);
router.get('/', authenticate, authorize('readProduct'), getProducts);
router.get('/:id', authenticate, authorize('readProduct'), getProductById);
router.put('/:id', authenticate, authorize('updateProduct'), updateProduct);
router.delete('/:id', authenticate, authorize('deleteProduct'), deleteProduct);

module.exports = router;
