create database quiz;
use quiz;

CREATE TABLE quiz_question (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    correct_answer VARCHAR(255),
    question_text VARCHAR(255),
    quiz_type VARCHAR(255),
    quiz_category VARCHAR(255)
);

CREATE TABLE question_options (
    question_id BIGINT NOT NULL,
    option_text VARCHAR(255),
    KEY (question_id)
);




INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Who invented Java Programming?', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Guido van Rossum', @QID),
('James Gosling', @QID),
('Dennis Ritchie', @QID),
('Bjarne Stroustrup', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which environment variable is used to set the java path?', 'd');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('MAVEN_PATH', @QID),
('JavaPATH', @QID),
('JAVA', @QID),
('JAVA_HOME', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which of the following is not an OOPS concept in Java?', 'c');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Inheritance', @QID),
('Encapsulation', @QID),
('Compilation', @QID),
('Polymorphism', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('What is not the use of “this” keyword in Java?', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Referring current class instance variable', @QID),
('Passing itself to static methods', @QID),
('Passing itself to another method', @QID),
('Calling another constructor in constructor chaining', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('When is the object created with new keyword?', 'a');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('At run time', @QID),
('At compile time', @QID),
('While loading', @QID),
('During linking', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Arrays in java are', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Object references', @QID),
('Objects', @QID),
('Primitive data type', @QID),
('None of the above', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which keyword prevents a Java class from being subclassed?', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('abstract', @QID),
('final', @QID),
('static', @QID),
('volatile', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('What value does Integer.compare(3, 5) return?', 'a');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('-1', @QID),
('0', @QID),
('1', @QID),
('2', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which generic method declaration correctly returns the maximum of two Comparable elements?', 'a');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('public static <T extends Comparable<T>> T max(T a, T b)', @QID),
('public static T max<T extends Comparable<T>>(T a, T b)', @QID),
('public static <T> T max(T a, T b)', @QID),
('public static Comparable max(Comparable a, Comparable b)', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('What is the default load factor for java.util.HashMap?', 'a');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('0.75', @QID),
('0.50', @QID),
('1.00', @QID),
('0.65', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which interface provides the submit() method that returns a Future?', 'd');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Callable', @QID),
('Executor', @QID),
('Runnable', @QID),
('ExecutorService', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('In the Java Memory Model, the volatile keyword guarantees:', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Atomicity', @QID),
('Visibility', @QID),
('Mutability', @QID),
('Serialization order', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which garbage collector is the default in JDK 17 on server-class machines?', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Serial GC', @QID),
('G1 GC', @QID),
('Shenandoah', @QID),
('ZGC', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('To customise class loading, which ClassLoader method do you typically override?', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('loadClass()', @QID),
('findClass()', @QID),
('defineClass()', @QID),
('resolveClass()', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('In the Java Platform Module System, which directive exports a package only to specific modules?', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('exports com.example.pkg;', @QID),
('exports com.example.pkg to modA,modB;', @QID),
('opens com.example.pkg;', @QID),
('provides com.example.pkg;', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which of the following statements about java.lang.String is TRUE?', 'd');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('String objects are mutable', @QID),
('String is not final', @QID),
('String internally stores characters in char[] starting JDK 9', @QID),
('String is immutable and final', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('What happens when a checked exception is thrown but not caught in Java?', 'c');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('It is ignored', @QID),
('The JVM immediately halts', @QID),
('The method must declare it with throws', @QID),
('It becomes an unchecked exception', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which functional interface is used by the Stream API’s filter() method?', 'a');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('java.util.function.Predicate', @QID),
('java.util.function.Function', @QID),
('java.util.function.Supplier', @QID),
('java.util.function.Consumer', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('What does the "try-with-resources" statement guarantee?', 'a');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Automatic closing of resources implementing AutoCloseable', @QID),
('Rollback of transactions', @QID),
('Suppression of all exceptions', @QID),
('Implicit catch of RuntimeExceptions', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which method on a java.util.Stream causes its pipeline to execute?', 'c');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('map()', @QID),
('filter()', @QID),
('collect()', @QID),
('peek()', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('What is the purpose of the java.lang.invoke.MethodHandle API?', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Runtime code generation of new classes', @QID),
('Typed, direct reference to underlying methods for dynamic invocation', @QID),
('Generating proxy classes automatically', @QID),
('Compiling Java source at runtime', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which annotation marks a method whose return value must not be ignored?', 'c');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('@Retention', @QID),
('@SafeVarargs', @QID),
('@CheckReturnValue', @QID),
('@Native', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('What is printed by this code?  System.out.println(1.0 / 0);', 'd');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('InfinityException', @QID),
('0', @QID),
('ArithmeticException', @QID),
('Infinity', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which java.time class would you use to represent a date without a time-of-day or timezone?', 'b');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Instant', @QID),
('LocalDate', @QID),
('ZonedDateTime', @QID),
('OffsetDateTime', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which switch feature was finalized (no longer preview) in Java 17?', 'c');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Switch expressions with yield', @QID),
('Pattern matching for instanceof', @QID),
('Switch expressions with -> and multiple labels', @QID),
('String templates in switch', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('When a CompletableFuture is completed exceptionally, calling join() will throw:', 'a');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('CompletionException', @QID),
('ExecutionException', @QID),
('InterruptedException', @QID),
('IllegalStateException', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('Which of these collections is thread-safe without external synchronisation?', 'a');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('ConcurrentHashMap', @QID),
('ArrayList', @QID),
('HashSet', @QID),
('LinkedList', @QID);

INSERT INTO quiz_question (question_text, correct_answer)
VALUES ('In Java records, which component can NOT be declared?', 'c');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Static fields', @QID),
('Static methods', @QID),
('Instance mutable fields outside the canonical constructor', @QID),
('Instance methods', @QID);


ALTER TABLE quiz_question ADD COLUMN category VARCHAR(50);
UPDATE quiz_question SET category = 'java';



-- Python Questions

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Who developed Python Programming Language?', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Wick van Rossum', @QID),
('Rasmus Lerdorf', @QID),
('Guido van Rossum', @QID),
('Niene Stom', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which type of Programming does Python support?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('object-oriented programming', @QID),
('structured programming', @QID),
('functional programming', @QID),
('all of the mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Is Python case sensitive when dealing with identifiers?', 'b', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('no', @QID),
('yes', @QID),
('machine dependent', @QID),
('none of the mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following is the correct extension of the Python file?', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('.python', @QID),
('.pl', @QID),
('.py', @QID),
('.p', @QID);



INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which function is used to create an array in NumPy?', 'b', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('numpy.create()', @QID),
('numpy.array()', @QID),
('numpy.make_array()', @QID),
('numpy.generate()', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What does the numpy.zeros() function return?', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('An array of random values', @QID),
('An identity matrix', @QID),
('An array of zeros', @QID),
('An array of ones', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which method is used to reshape a numpy array?', 'a', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('reshape()', @QID),
('restructure()', @QID),
('resize()', @QID),
('reshape_array()', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What does numpy.mean() compute?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Median of array', @QID),
('Mode of array', @QID),
('Standard deviation', @QID),
('Average of array elements', @QID);


INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which class is used for handling tabular data in pandas?', 'a', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('DataFrame', @QID),
('Series', @QID),
('Panel', @QID),
('Matrix', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What does the pandas read_csv() function do?', 'b', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Writes a CSV file', @QID),
('Reads a CSV file into a DataFrame', @QID),
('Creates a CSV file', @QID),
('Deletes a CSV file', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which method is used to check for missing values in pandas?', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('isnulls()', @QID),
('checkna()', @QID),
('isnull()', @QID),
('ismissing()', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('How can you select the first 5 rows of a DataFrame?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('df.select(5)', @QID),
('df.get_rows(5)', @QID),
('df.head_rows(5)', @QID),
('df.head(5)', @QID);


INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What arithmetic operators cannot be used with strings in Python?', 'b', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('*', @QID),
('-', @QID),
('+', @QID),
('All of the mentioned', @QID);


INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following statements is used to create an empty set in Python?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('()', @QID),
('{}', @QID),
('[]', @QID),
('set()', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('To add a new element to a list we use which Python command', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('list1.addEnd(5)', @QID),
('list1.addLast(5)', @QID),
('list1.append(5)', @QID),
('list1.add(5)', @QID);

CREATE DATABASE IF NOT EXISTS quiz;
USE quiz;

-- Python Questions

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which one of the following is the use of function in python?', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Functions don’t provide better modularity for your application', @QID),
('you can’t also create your own functions', @QID),
('Functions are reusable pieces of programs', @QID),
('All of the mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What is the maximum possible length of an identifier in Python?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('79 characters', @QID),
('31 characters', @QID),
('63 characters', @QID),
('none of the mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What are the two main types of functions in Python?', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('System function', @QID),
('Custom function', @QID),
('Built-in function & User defined function', @QID),
('User function', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following is a Python tuple?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('{1, 2, 3}', @QID),
('{}', @QID),
('[1, 2, 3]', @QID),
('(1, 2, 3)', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What is output of print(math.pow(3, 2))?', 'a', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('9.0', @QID),
('None', @QID),
('9', @QID),
('None of the mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following is the use of id() function in python?', 'b', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Every object in Python doesn’t have a unique id', @QID),
('In Python Id function returns the identity of the object', @QID),
('None of the mentioned', @QID),
('All of the mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('The process of pickling in Python includes ____________', 'a', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('conversion of a Python object hierarchy into byte stream', @QID),
('conversion of a datatable into a list', @QID),
('conversion of a byte stream into Python object hierarchy', @QID),
('conversion of a list into a datatable', @QID);

-- Pandas Questions

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('The result of an operation between unaligned Series will have the ________ of the indexes involved.', 'b', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('intersection', @QID),
('union', @QID),
('total', @QID),
('all of the mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following input can be accepted by DataFrame?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('Structured ndarray', @QID),
('Series', @QID),
('DataFrame', @QID),
('All of the mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('If data is an ndarray, index must be the same length as data.', 'a', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('True', @QID),
('False', @QID);

-- NumPy Questions

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What will be the minimum number of arguments require to pass in pandas series?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('2', @QID),
('3', @QID),
('4', @QID),
('None of the above mentioned', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What is the purpose of NumPy in Python?', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('To do numerical calculations', @QID),
('To do scientific computing', @QID),
('Both A and B', @QID),
('None of the mentioned above', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Using ndim we can find -', 'a', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('We can find the dimension of the array', @QID),
('Size of array', @QID),
('Operational activities on Matrix', @QID),
('None of the mentioned above', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('What is the default data type of NumPy arrays?', 'b', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('int32', @QID),
('float64', @QID),
('object', @QID),
('None of the above', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following is used to create an identity matrix in NumPy?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('zeros()', @QID),
('ones()', @QID),
('arange()', @QID),
('eye()', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following is used to reshape a NumPy array?', 'c', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('reshape()', @QID),
('resize()', @QID),
('Both A and B', @QID),
('None of the above', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following is used to find the maximum element in a NumPy array?', 'd', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('max()', @QID),
('maximum()', @QID),
('amax()', @QID),
('All of the above', @QID);

INSERT INTO quiz_question (question_text, correct_answer, category)
VALUES ('Which of the following is used to find the indices of the maximum and minimum elements in a NumPy array?', 'a', 'python');
SET @QID := LAST_INSERT_ID();
INSERT INTO question_options (option_text, question_id) VALUES
('argmax() and argmin()', @QID),
('max() and min()', @QID),
('amax() and amin()', @QID),
('None of the above', @QID);


select * from question_options;







