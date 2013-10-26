This is an example of Oriented-object database architecture implementation. All classes which are descendants of CModel can be saved and loaded in the database without any information of their properties.

Database and its tables will be automatically re-built every time you execute the application. I encouraged you to add new properties to existing classes or even to add new classes in the hierarchy at design time. To add new classes to the hierarchy you have only to declare the class in ClassesRTTI unit and to add its name in TPersistentClasses array.
You can also define different types of foreign keys when declaring the variables as you can see in class CContact (variable Address)
Pressing the button labeled 'Copy', model 1 will be copied into model 2.

