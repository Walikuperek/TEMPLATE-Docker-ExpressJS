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
