return {
	WrapInFunction = require("vertile.steps.WrapInFunction");
	SplitStrings   = require("vertile.steps.SplitStrings");
	Vmify          = require("vertile.steps.Vmify");
	ConstantArray  = require("vertile.steps.ConstantArray");
	ProxifyLocals  = require("vertile.steps.ProxifyLocals");
	AntiTamper  = require("vertile.steps.AntiTamper");
	EncryptStrings = require("vertile.steps.EncryptStrings");
	NumbersToExpressions = require("vertile.steps.NumbersToExpressions");
	AddVararg 	= require("vertile.steps.AddVararg");
}