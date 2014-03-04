import os

def process_model(model):
	if not model.appname:
		model.appname = 'Blues' if model.id > 162 else 'BluesPad'



def process_models(models):
	for model in models:
		process_model(modes)