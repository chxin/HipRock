import os

def process_model(model):
	if model.path:
		model.path += 'Blues.plist' if model.id > 162 else 'BluesPad.plist'



def process_models(models):
	for model in models:
		process_model(modes)