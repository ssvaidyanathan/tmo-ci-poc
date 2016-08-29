/* jslint node: true */
"use strict";

module.exports = function () {
	
	this.Then(/^I should get global variable for (.*)$/, function (variable, callback) {
		var value = this.apickli.getGlobalVariable(variable);
		callback();
	});

	this.When(/^I get the cart created$/, function (callback) {
		var cartId = this.apickli.getGlobalVariable("CartId");
        this.apickli.get("/v1/cart/"+cartId, function (error, response) {
            if (error) {
                callback(new Error(error));
            }
            callback();
        });
    });

    this.Then(/^value of body path (.*) should match with (.*) in global scope$/, function (path, globalVariableName, callback) {
		var responseValue = this.apickli.evaluatePathInResponseBody(path);
		var value = this.apickli.getGlobalVariable(globalVariableName);
		if(responseValue === null || value === null || responseValue !== value){
        	callback(new Error(globalVariableName + " in the global variable does not match with response"));
		}
		callback();
	});

	this.When(/^I update the cart$/, function (callback) {
		var cartId = this.apickli.getGlobalVariable("CartId");
		var cartItemId = this.apickli.getGlobalVariable("CartItemId");
		var data = this.apickli.requestBody;
		data = data.replace("{{CartId}}",cartId);
		data = data.replace("{{CartItemId}}",cartItemId);
		this.apickli.setRequestBody(data);
        this.apickli.post("/v1/cart/"+cartId+"/cartitem/"+cartItemId, function (error, response) {
            if (error) {
                callback(new Error(error));
            }
            callback();
        });
    });

};