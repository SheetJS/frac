from distutils.core import setup
setup(
	name='frac',
	version='1.0.2',
	author='SheetJS',
	author_email='dev@sheetjs.com',
	url='http://oss.sheetjs.com/frac',
	description='Rational approximations to numbers',
	long_description = """
Rational approximations to numbers

This module can generate fraction representations using:
- Mediant method (akin to fractions.Fraction#limit_denominator)
- Aberth method (as used by spreadsheet software)
""",
	platforms = ["any"],
	requires=[],
	py_modules=['frac'],
	scripts = [],
	license = "Apache-2.0",
	keywords = ['frac', 'fraction', 'rational', 'approximation'],
	classifiers = [
		'Development Status :: 5 - Production/Stable',
		'License :: OSI Approved :: Apache Software License',
		'Operating System :: OS Independent',
		'Topic :: Scientific/Engineering :: Mathematics',
		'Topic :: Utilities',
	]
)
