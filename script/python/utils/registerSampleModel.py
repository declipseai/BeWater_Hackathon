from web3Manager import * 
from ipfsManager import upload_file

# Model details
model_name = 'Resnet50'
model_type = 'ImgClassification'
quant_type = 'QuantType1'

# Register Resnet50 model
register_model(
    model_name,
    model_type,
    quant_type,
    'QmdDLcQmpYJVSXUGARBHuX9pg8NjRsGRtQ6CG3reYJ5BxG',
    'QmdDLcQmpYJVSXUGARBHuX9pg8NjRsGRtQ6CG3reYJ5BxG',
    'QmWkSunYiwYHncCTfLmGCgY74Q4iYPtgySpdpSQjA4PhmR',
    private_key
)

# Register Resnet101 model
register_model(
    'Resnet101',
    model_type,
    quant_type,
    'QmTXjamz1JifitNcSntiYwVKaDqKxMtdBz2BMkpSEEyYGP',
    'QmTXjamz1JifitNcSntiYwVKaDqKxMtdBz2BMkpSEEyYGP',
    'QmTbYg2HvQbwygGsNuYuwR4ZuvyXvvGLkg47TvcVgV5Qf1',
    private_key
)

# Register Resnet152 model
register_model(
    'Resnet152',
    model_type,
    quant_type,
    'QmQJ5TtJzWU8pfGEWcNPe9KTgvUyGjoJFnHRgZGQFCCrf4',
    'QmQJ5TtJzWU8pfGEWcNPe9KTgvUyGjoJFnHRgZGQFCCrf4',
    'QmfGfrucitqafzs534A1HVUggdaSpM8Kgu9tkfhVvdE1uq',
    private_key
)