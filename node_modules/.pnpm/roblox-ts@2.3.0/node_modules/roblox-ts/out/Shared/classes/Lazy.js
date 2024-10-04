"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Lazy = void 0;
class Lazy {
    constructor(getValue) {
        this.getValue = getValue;
        this.isInitialized = false;
    }
    get() {
        if (!this.isInitialized) {
            this.isInitialized = true;
            this.value = this.getValue();
        }
        return this.value;
    }
    set(value) {
        this.isInitialized = true;
        this.value = value;
    }
}
exports.Lazy = Lazy;
//# sourceMappingURL=Lazy.js.map