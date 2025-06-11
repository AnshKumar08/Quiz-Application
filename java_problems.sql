create database quiz;
use quiz;

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
