import os

def process_model(model):
	if model.path:
		model.path += 'BluesPad.plist' if model.id > 162 else 'Blues.plist'



def process_models(models):
	for model in models:
		process_model(modes)