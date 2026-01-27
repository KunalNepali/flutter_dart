import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/quiz_category.dart';
import '../models/quiz_result.dart';

class StorageService {
  static const String _categoriesKey = 'quiz_categories';
  static const String _questionsKey = 'quiz_questions';
  static const String _resultsKey = 'quiz_results';
  static const String _userProgressKey = 'user_progress';

  static Future<SharedPreferences> get _prefs async => 
    await SharedPreferences.getInstance();
  // Reset all app data
  static Future<void> resetAllData() async {
    final prefs = await _prefs;
    
    // Clear all stored data
    await prefs.clear();
    
    // Re-initialize default categories and questions
    await _initializeDefaultCategories();
  }

  // Reset progress for a specific category
  static Future<void> resetCategoryProgress(String categoryId) async {
    final categories = await loadCategories();
    final index = categories.indexWhere((c) => c.id == categoryId);
    
    if (index != -1) {
      categories[index].isCompleted = false;
      categories[index].highestScore = 0.0;
      await saveCategories(categories);
      
      // Reset questions for this category
      final questions = await loadQuestions(categoryId);
      final resetQuestions = questions.map((question) {
        return Question(
          id: question.id,
          categoryId: question.categoryId,
          text: question.text,
          options: question.options,
          correctAnswerIndex: question.correctAnswerIndex,
          selectedAnswerIndex: null,
          explanation: question.explanation,
        );
      }).toList();
      
      await saveQuestions(categoryId, resetQuestions);
    }
  }

  // Delete all quiz results
  static Future<void> clearAllResults() async {
    final prefs = await _prefs;
    await prefs.remove(_resultsKey);
  }

  // Export data (for backup)
  static Future<Map<String, dynamic>> exportData() async {
    final categories = await loadCategories();
    final results = await loadResults();
    
    return {
      'categories': categories.map((c) => c.toJson()).toList(),
      'results': results.map((r) => r.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  // Import data (for restore)
  static Future<void> importData(Map<String, dynamic> data) async {
    final prefs = await _prefs;
    
    if (data['categories'] != null) {
      final jsonString = json.encode(data['categories']);
      await prefs.setString(_categoriesKey, jsonString);
    }
    
    if (data['results'] != null) {
      final jsonString = json.encode(data['results']);
      await prefs.setString(_resultsKey, jsonString);
    }
  }

  // Categories
  static Future<List<QuizCategory>> loadCategories() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_categoriesKey);
    
    if (jsonString == null) {
      return await _initializeDefaultCategories();
    }
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => QuizCategory.fromJson(json)).toList();
  }

  static Future<void> saveCategories(List<QuizCategory> categories) async {
    final prefs = await _prefs;
    final jsonString = json.encode(categories.map((c) => c.toJson()).toList());
    await prefs.setString(_categoriesKey, jsonString);
  }

  static Future<void> updateCategoryProgress(
    String categoryId, 
    double score
  ) async {
    final categories = await loadCategories();
    final index = categories.indexWhere((c) => c.id == categoryId);
    
    if (index != -1) {
      categories[index].isCompleted = true;
      if (score > categories[index].highestScore) {
        categories[index].highestScore = score;
      }
      await saveCategories(categories);
    }
  }

  // Questions
  static Future<List<Question>> loadQuestions(String categoryId) async {
    final prefs = await _prefs;
    final key = '${_questionsKey}_$categoryId';
    final jsonString = prefs.getString(key);
    
    if (jsonString == null) {
      return await _initializeSampleQuestions(categoryId);
    }
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Question.fromJson(json)).toList();
  }

  static Future<void> saveQuestions(
    String categoryId, 
    List<Question> questions
  ) async {
    final prefs = await _prefs;
    final key = '${_questionsKey}_$categoryId';
    final jsonString = json.encode(questions.map((q) => q.toJson()).toList());
    await prefs.setString(key, jsonString);
  }

  // Results
  static Future<List<QuizResult>> loadResults() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_resultsKey);
    
    if (jsonString == null) {
      return [];
    }
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => QuizResult.fromJson(json)).toList();
  }

  static Future<void> saveResult(QuizResult result) async {
    final results = await loadResults();
    results.add(result);
    
    final prefs = await _prefs;
    final jsonString = json.encode(results.map((r) => r.toJson()).toList());
    await prefs.setString(_resultsKey, jsonString);
  }

  // Private Methods
  static Future<List<QuizCategory>> _initializeDefaultCategories() async {
    final defaultCategories = [
      QuizCategory(
        id: 'geography',
        name: 'Geography',
        description: 'Nepal and world geography questions',
        questionCount: 50,
        icon: '🌍',
      ),
      QuizCategory(
        id: 'history',
        name: 'History',
        description: 'Nepal and world history questions',
        questionCount: 50,
        icon: '📜',
      ),
      QuizCategory(
        id: 'current_affairs',
        name: 'Current Affairs',
        description: 'Latest national and international news',
        questionCount: 50,
        icon: '📰',
      ),
      QuizCategory(
        id: 'mathematics',
        name: 'Mathematics',
        description: 'Basic and advanced mathematics',
        questionCount: 50,
        icon: '🧮',
      ),
      QuizCategory(
        id: 'critical_thinking',
        name: 'Critical Thinking',
        description: 'Logical reasoning and problem solving',
        questionCount: 50,
        icon: '💭',
      ),
    ];

    await saveCategories(defaultCategories);
    
    // Initialize questions for each category
    for (final category in defaultCategories) {
      await _initializeSampleQuestions(category.id);
    }
    
    return defaultCategories;
  }

  static Future<List<Question>> _initializeSampleQuestions(String categoryId) async {
    List<Question> questions = [];
    
    switch (categoryId) {
      case 'geography':
        questions = _getGeographyQuestions();
        break;
      case 'history':
        questions = _getHistoryQuestions();
        break;
      case 'current_affairs':
        questions = _getCurrentAffairsQuestions();
        break;
      case 'mathematics':
        questions = _getMathematicsQuestions();
        break;
      case 'critical_thinking':
        questions = _getCriticalThinkingQuestions();
        break;
      default:
        questions = _getGeographyQuestions();
    }

    await saveQuestions(categoryId, questions);
    return questions;
  }

  // Geography Questions (50 questions)
  static List<Question> _getGeographyQuestions() {
    return [
      Question(
        id: 'geo_1',
        categoryId: 'geography',
        text: 'What is the capital of Nepal?',
        options: ['Kathmandu', 'Pokhara', 'Biratnagar', 'Birgunj'],
        correctAnswerIndex: 0,
        explanation: 'Kathmandu is the capital and largest city of Nepal.',
      ),
      Question(
        id: 'geo_2',
        categoryId: 'geography',
        text: 'Which is the highest mountain in the world?',
        options: ['K2', 'Kangchenjunga', 'Mount Everest', 'Lhotse'],
        correctAnswerIndex: 2,
        explanation: 'Mount Everest is the highest mountain above sea level at 8,848 meters.',
      ),
      Question(
        id: 'geo_3',
        categoryId: 'geography',
        text: 'Which river is known as the "Sorrow of Bihar"?',
        options: ['Gandaki', 'Koshi', 'Bagmati', 'Karnali'],
        correctAnswerIndex: 1,
        explanation: 'Koshi River is called the "Sorrow of Bihar" due to its frequent flooding.',
      ),
      Question(
        id: 'geo_4',
        categoryId: 'geography',
        text: 'What is the largest lake in Nepal?',
        options: ['Phewa Lake', 'Rara Lake', 'Begnas Lake', 'Tilicho Lake'],
        correctAnswerIndex: 1,
        explanation: 'Rara Lake is the largest lake in Nepal with an area of 10.8 km².',
      ),
      Question(
        id: 'geo_5',
        categoryId: 'geography',
        text: 'Which district of Nepal is known as "The Gateway to Mount Everest"?',
        options: ['Solukhumbu', 'Mustang', 'Dolakha', 'Sankhuwasabha'],
        correctAnswerIndex: 0,
        explanation: 'Solukhumbu district is known as the gateway to Mount Everest.',
      ),
      Question(
        id: 'geo_6',
        categoryId: 'geography',
        text: 'How many provinces are there in Nepal?',
        options: ['5', '6', '7', '8'],
        correctAnswerIndex: 2,
        explanation: 'Nepal is divided into 7 provinces according to the Constitution of Nepal 2015.',
      ),
      Question(
        id: 'geo_7',
        categoryId: 'geography',
        text: 'Which is the smallest district of Nepal by area?',
        options: ['Bhaktapur', 'Lalitpur', 'Kathmandu', 'Kavrepalanchok'],
        correctAnswerIndex: 0,
        explanation: 'Bhaktapur is the smallest district with an area of 119 km².',
      ),
      Question(
        id: 'geo_8',
        categoryId: 'geography',
        text: 'What is the altitude of Mount Everest?',
        options: ['8,586 m', '8,748 m', '8,848 m', '8,946 m'],
        correctAnswerIndex: 2,
        explanation: 'Mount Everest stands at 8,848 meters (29,029 feet) above sea level.',
      ),
      Question(
        id: 'geo_9',
        categoryId: 'geography',
        text: 'Which national park is the first national park of Nepal?',
        options: ['Chitwan National Park', 'Bardiya National Park', 'Sagarmatha National Park', 'Langtang National Park'],
        correctAnswerIndex: 0,
        explanation: 'Chitwan National Park, established in 1973, is the first national park of Nepal.',
      ),
      Question(
        id: 'geo_10',
        categoryId: 'geography',
        text: 'Which river separates Nepal from India in the western region?',
        options: ['Mahakali', 'Karnali', 'Gandaki', 'Koshi'],
        correctAnswerIndex: 0,
        explanation: 'Mahakali River forms the western border between Nepal and India.',
      ),
      Question(
        id: 'geo_11',
        categoryId: 'geography',
        text: 'What is the highest altitude airport in Nepal?',
        options: ['Tenzing-Hillary Airport', 'Jomsom Airport', 'Simikot Airport', 'Dolpa Airport'],
        correctAnswerIndex: 0,
        explanation: 'Tenzing-Hillary Airport in Lukla is at 2,860 meters, the highest altitude airport.',
      ),
      Question(
        id: 'geo_12',
        categoryId: 'geography',
        text: 'Which district is known as "The Land of Rhododendron"?',
        options: ['Taplejung', 'Ilam', 'Panchthar', 'Terhathum'],
        correctAnswerIndex: 1,
        explanation: 'Ilam district is famous for its rhododendron forests.',
      ),
      Question(
        id: 'geo_13',
        categoryId: 'geography',
        text: 'What percentage of Nepal\'s land is covered by forest?',
        options: ['25%', '29%', '37%', '45%'],
        correctAnswerIndex: 3,
        explanation: 'Approximately 45% of Nepal\'s total land area is covered by forests.',
      ),
      Question(
        id: 'geo_14',
        categoryId: 'geography',
        text: 'Which is the deepest gorge in the world located in Nepal?',
        options: ['Kali Gandaki Gorge', 'Marsyangdi Gorge', 'Trishuli Gorge', 'Bheri Gorge'],
        correctAnswerIndex: 0,
        explanation: 'Kali Gandaki Gorge is considered the deepest gorge in the world.',
      ),
      Question(
        id: 'geo_15',
        categoryId: 'geography',
        text: 'How many UNESCO World Heritage Sites are there in Nepal?',
        options: ['4', '6', '8', '10'],
        correctAnswerIndex: 3,
        explanation: 'Nepal has 10 UNESCO World Heritage Sites.',
      ),
      Question(
        id: 'geo_16',
        categoryId: 'geography',
        text: 'Which is the largest district of Nepal by area?',
        options: ['Dolpa', 'Humla', 'Mugu', 'Darchula'],
        correctAnswerIndex: 0,
        explanation: 'Dolpa is the largest district with an area of 7,889 km².',
      ),
      Question(
        id: 'geo_17',
        categoryId: 'geography',
        text: 'What is the longest river in Nepal?',
        options: ['Karnali', 'Koshi', 'Gandaki', 'Mahakali'],
        correctAnswerIndex: 1,
        explanation: 'Koshi River is the longest river in Nepal at 729 km.',
      ),
      Question(
        id: 'geo_18',
        categoryId: 'geography',
        text: 'Which mountain range forms the border between Nepal and Tibet?',
        options: ['Mahalangur Range', 'Annapurna Range', 'Dhaulagiri Range', 'Himalayan Range'],
        correctAnswerIndex: 3,
        explanation: 'The Himalayan Range forms the natural border between Nepal and Tibet.',
      ),
      Question(
        id: 'geo_19',
        categoryId: 'geography',
        text: 'What is the total area of Nepal in square kilometers?',
        options: ['147,181', '147,516', '147,181', '147,181'],
        correctAnswerIndex: 1,
        explanation: 'Nepal covers an area of 147,516 square kilometers.',
      ),
      Question(
        id: 'geo_20',
        categoryId: 'geography',
        text: 'Which is the highest lake in the world located in Nepal?',
        options: ['Gokyo Lake', 'Tilicho Lake', 'Shey Phoksundo Lake', 'Rara Lake'],
        correctAnswerIndex: 1,
        explanation: 'Tilicho Lake at 4,919 meters is considered the highest lake in the world.',
      ),
      Question(
        id: 'geo_21',
        categoryId: 'geography',
        text: 'What is the latitude range of Nepal?',
        options: ['26°N to 30°N', '27°N to 31°N', '28°N to 32°N', '29°N to 33°N'],
        correctAnswerIndex: 0,
        explanation: 'Nepal lies between 26°N to 30°N latitude.',
      ),
      Question(
        id: 'geo_22',
        categoryId: 'geography',
        text: 'Which is the only city in Nepal with a metro system?',
        options: ['Kathmandu', 'Pokhara', 'Biratnagar', 'None of the above'],
        correctAnswerIndex: 3,
        explanation: 'Nepal does not have any metro system currently.',
      ),
      Question(
        id: 'geo_23',
        categoryId: 'geography',
        text: 'What is the name of the glacier that feeds the Ganges River?',
        options: ['Gangotri Glacier', 'Siachen Glacier', 'Zemu Glacier', 'Ngozumpa Glacier'],
        correctAnswerIndex: 0,
        explanation: 'Gangotri Glacier in the Himalayas feeds the Ganges River.',
      ),
      Question(
        id: 'geo_24',
        categoryId: 'geography',
        text: 'Which district is known as "The Orange County" of Nepal?',
        options: ['Syangja', 'Palpa', 'Gulmi', 'Tanahun'],
        correctAnswerIndex: 2,
        explanation: 'Gulmi district is famous for orange production.',
      ),
      Question(
        id: 'geo_25',
        categoryId: 'geography',
        text: 'How many peaks in Nepal are over 8,000 meters?',
        options: ['6', '8', '10', '12'],
        correctAnswerIndex: 1,
        explanation: 'There are 8 peaks over 8,000 meters in Nepal.',
      ),
      Question(
        id: 'geo_26',
        categoryId: 'geography',
        text: 'Which is the only national park in Nepal located in the Trans-Himalayan region?',
        options: ['Shey Phoksundo National Park', 'Makalu Barun National Park', 'Rara National Park', 'Khaptad National Park'],
        correctAnswerIndex: 0,
        explanation: 'Shey Phoksundo National Park is in the Trans-Himalayan region.',
      ),
      Question(
        id: 'geo_27',
        categoryId: 'geography',
        text: 'What is the average width of Nepal from east to west?',
        options: ['193 km', '241 km', '289 km', '337 km'],
        correctAnswerIndex: 1,
        explanation: 'The average width of Nepal is approximately 241 km.',
      ),
      Question(
        id: 'geo_28',
        categoryId: 'geography',
        text: 'Which river is known as "Narayani" in Nepal?',
        options: ['Karnali', 'Gandaki', 'Koshi', 'Mahakali'],
        correctAnswerIndex: 1,
        explanation: 'Gandaki River is called Narayani in the southern plains.',
      ),
      Question(
        id: 'geo_29',
        categoryId: 'geography',
        text: 'What is the highest waterfall in Nepal?',
        options: ['Hyatung Waterfall', 'Rani Waterfall', 'Davis Falls', 'Sundarijal Waterfall'],
        correctAnswerIndex: 0,
        explanation: 'Hyatung Waterfall in Taplejung is the highest at 365 meters.',
      ),
      Question(
        id: 'geo_30',
        categoryId: 'geography',
        text: 'Which is the largest national park in Nepal?',
        options: ['Chitwan National Park', 'Bardiya National Park', 'Shey Phoksundo National Park', 'Makalu Barun National Park'],
        correctAnswerIndex: 3,
        explanation: 'Makalu Barun National Park is the largest with an area of 1,500 km².',
      ),
      Question(
        id: 'geo_31',
        categoryId: 'geography',
        text: 'What is the length of Nepal from east to west?',
        options: ['800 km', '885 km', '950 km', '1,020 km'],
        correctAnswerIndex: 1,
        explanation: 'Nepal stretches about 885 km from east to west.',
      ),
      Question(
        id: 'geo_32',
        categoryId: 'geography',
        text: 'Which district has the highest literacy rate in Nepal?',
        options: ['Kathmandu', 'Lalitpur', 'Kaski', 'Bhaktapur'],
        correctAnswerIndex: 1,
        explanation: 'Lalitpur district has the highest literacy rate at 81.5%.',
      ),
      Question(
        id: 'geo_33',
        categoryId: 'geography',
        text: 'What is the name of the desert region in Nepal?',
        options: ['Mustang Desert', 'Manang Desert', 'Dolpo Desert', 'Upper Mustang Desert'],
        correctAnswerIndex: 3,
        explanation: 'Upper Mustang is often called a cold desert due to its arid climate.',
      ),
      Question(
        id: 'geo_34',
        categoryId: 'geography',
        text: 'Which is the only river in Nepal that flows north?',
        options: ['Karnali', 'Gandaki', 'Koshi', 'None of the above'],
        correctAnswerIndex: 3,
        explanation: 'All major rivers in Nepal flow from north to south.',
      ),
      Question(
        id: 'geo_35',
        categoryId: 'geography',
        text: 'What is the altitude of Kathmandu Valley?',
        options: ['1,100 m', '1,300 m', '1,500 m', '1,700 m'],
        correctAnswerIndex: 1,
        explanation: 'Kathmandu Valley is at approximately 1,300 meters above sea level.',
      ),
      Question(
        id: 'geo_36',
        categoryId: 'geography',
        text: 'Which district is known for the "Mardi Himal" trek?',
        options: ['Kaski', 'Myagdi', 'Baglung', 'Lamjung'],
        correctAnswerIndex: 0,
        explanation: 'Mardi Himal trek is in Kaski district.',
      ),
      Question(
        id: 'geo_37',
        categoryId: 'geography',
        text: 'How many ecological zones are there in Nepal?',
        options: ['3', '4', '5', '6'],
        correctAnswerIndex: 2,
        explanation: 'Nepal has 5 ecological zones: Terai, Siwalik, Middle Mountains, High Mountains, and High Himalayas.',
      ),
      Question(
        id: 'geo_38',
        categoryId: 'geography',
        text: 'Which is the largest city in Nepal by population?',
        options: ['Kathmandu', 'Pokhara', 'Biratnagar', 'Lalitpur'],
        correctAnswerIndex: 0,
        explanation: 'Kathmandu is the most populous city in Nepal.',
      ),
      Question(
        id: 'geo_39',
        categoryId: 'geography',
        text: 'What is the name of the bridge that connects Nepal and China?',
        options: ['Friendship Bridge', 'Sino-Nepal Bridge', 'Himalayan Bridge', 'Trans-Himalayan Bridge'],
        correctAnswerIndex: 0,
        explanation: 'The Friendship Bridge connects Nepal and China at the Tibet border.',
      ),
      Question(
        id: 'geo_40',
        categoryId: 'geography',
        text: 'Which is the only district in Nepal without any rivers?',
        options: ['Mustang', 'Manang', 'Dolpa', 'All districts have rivers'],
        correctAnswerIndex: 3,
        explanation: 'All districts in Nepal have rivers or streams.',
      ),
      Question(
        id: 'geo_41',
        categoryId: 'geography',
        text: 'What is the average annual rainfall in Kathmandu?',
        options: ['1,200 mm', '1,400 mm', '1,600 mm', '1,800 mm'],
        correctAnswerIndex: 1,
        explanation: 'Kathmandu receives about 1,400 mm of rainfall annually.',
      ),
      Question(
        id: 'geo_42',
        categoryId: 'geography',
        text: 'Which district is known as "The Land of Thunder Dragon"?',
        options: ['Mustang', 'Dolpa', 'Humla', 'Mugu'],
        correctAnswerIndex: 0,
        explanation: 'Upper Mustang is often called the Land of Thunder Dragon.',
      ),
      Question(
        id: 'geo_43',
        categoryId: 'geography',
        text: 'What is the highest temperature ever recorded in Nepal?',
        options: ['42°C', '45°C', '48°C', '51°C'],
        correctAnswerIndex: 1,
        explanation: 'The highest recorded temperature in Nepal is 45°C in Dhangadhi.',
      ),
      Question(
        id: 'geo_44',
        categoryId: 'geography',
        text: 'Which national park is famous for one-horned rhinoceros?',
        options: ['Chitwan National Park', 'Bardiya National Park', 'Suklaphanta National Park', 'Parsa National Park'],
        correctAnswerIndex: 0,
        explanation: 'Chitwan National Park is famous for one-horned rhinoceros.',
      ),
      Question(
        id: 'geo_45',
        categoryId: 'geography',
        text: 'How many airports are there in Nepal?',
        options: ['35', '40', '45', '50'],
        correctAnswerIndex: 2,
        explanation: 'Nepal has 45 airports including domestic and international airports.',
      ),
      Question(
        id: 'geo_46',
        categoryId: 'geography',
        text: 'Which district has the lowest population density in Nepal?',
        options: ['Manang', 'Mustang', 'Dolpa', 'Mugu'],
        correctAnswerIndex: 0,
        explanation: 'Manang has the lowest population density at 3 persons per km².',
      ),
      Question(
        id: 'geo_47',
        categoryId: 'geography',
        text: 'What is the name of the deepest cave in Nepal?',
        options: ['Gupteshwor Cave', 'Siddha Cave', 'Maire Cave', 'Chamere Cave'],
        correctAnswerIndex: 2,
        explanation: 'Maire Cave in Pokhara is the deepest at 1,400 meters.',
      ),
      Question(
        id: 'geo_48',
        categoryId: 'geography',
        text: 'Which is the oldest national park in Nepal?',
        options: ['Chitwan National Park', 'Langtang National Park', 'Sagarmatha National Park', 'Rara National Park'],
        correctAnswerIndex: 0,
        explanation: 'Chitwan National Park, established in 1973, is the oldest.',
      ),
      Question(
        id: 'geo_49',
        categoryId: 'geography',
        text: 'What percentage of the world\'s mountains are in Nepal?',
        options: ['8%', '12%', '16%', '20%'],
        correctAnswerIndex: 0,
        explanation: 'About 8% of the world\'s mountains are in Nepal.',
      ),
      Question(
        id: 'geo_50',
        categoryId: 'geography',
        text: 'Which district is known as "The Potato District"?',
        options: ['Jumla', 'Kalikot', 'Bajura', 'Bajhang'],
        correctAnswerIndex: 0,
        explanation: 'Jumla is famous for its high-quality potatoes.',
      ),
    ];
  }

  // History Questions (50 questions)
  static List<Question> _getHistoryQuestions() {
    return [
      Question(
        id: 'hist_1',
        categoryId: 'history',
        text: 'When was Nepal unified by King Prithvi Narayan Shah?',
        options: ['1743 AD', '1768 AD', '1786 AD', '1791 AD'],
        correctAnswerIndex: 1,
        explanation: 'Nepal was unified in 1768 AD by King Prithvi Narayan Shah.',
      ),
      Question(
        id: 'hist_2',
        categoryId: 'history',
        text: 'Who was the first King of unified Nepal?',
        options: ['Tribhuvan', 'Prithvi Narayan Shah', 'Rana Bahadur Shah', 'Surendra'],
        correctAnswerIndex: 1,
        explanation: 'Prithvi Narayan Shah was the first King of unified Nepal.',
      ),
      Question(
        id: 'hist_3',
        categoryId: 'history',
        text: 'When did the Rana regime end in Nepal?',
        options: ['1947', '1950', '1951', '1955'],
        correctAnswerIndex: 2,
        explanation: 'The Rana regime ended on February 18, 1951.',
      ),
      Question(
        id: 'hist_4',
        categoryId: 'history',
        text: 'Who was the first Prime Minister of Nepal?',
        options: ['Bhimsen Thapa', 'Jung Bahadur Rana', 'Mohan Shumsher', 'Bishweshwar Prasad Koirala'],
        correctAnswerIndex: 0,
        explanation: 'Bhimsen Thapa served as the first Prime Minister of Nepal from 1806 to 1837.',
      ),
      Question(
        id: 'hist_5',
        categoryId: 'history',
        text: 'When was democracy first established in Nepal?',
        options: ['1950', '1951', '1959', '1960'],
        correctAnswerIndex: 2,
        explanation: 'Democracy was first established in 1959 with the first general election.',
      ),
      Question(
        id: 'hist_6',
        categoryId: 'history',
        text: 'Who led the 1950 revolution against the Rana regime?',
        options: ['King Tribhuvan', 'King Mahendra', 'B.P. Koirala', 'Mohan Shumsher'],
        correctAnswerIndex: 0,
        explanation: 'King Tribhuvan led the revolution against the Rana regime in 1950.',
      ),
      Question(
        id: 'hist_7',
        categoryId: 'history',
        text: 'When was the Kot Massacre?',
        options: ['1842', '1846', '1850', '1854'],
        correctAnswerIndex: 1,
        explanation: 'The Kot Massacre occurred on September 14, 1846.',
      ),
      Question(
        id: 'hist_8',
        categoryId: 'history',
        text: 'Who started the Rana regime in Nepal?',
        options: ['Bhimsen Thapa', 'Jung Bahadur Rana', 'Ranodip Singh', 'Bir Shumsher'],
        correctAnswerIndex: 1,
        explanation: 'Jung Bahadur Rana established the Rana regime after the Kot Massacre.',
      ),
      Question(
        id: 'hist_9',
        categoryId: 'history',
        text: 'When was the Sugauli Treaty signed?',
        options: ['1814', '1815', '1816', '1817'],
        correctAnswerIndex: 2,
        explanation: 'The Sugauli Treaty was signed on March 4, 1816.',
      ),
      Question(
        id: 'hist_10',
        categoryId: 'history',
        text: 'Which battle marked the beginning of Anglo-Nepal War?',
        options: ['Battle of Nalapani', 'Battle of Jaithak', 'Battle of Makwanpur', 'Battle of Sindhuli'],
        correctAnswerIndex: 0,
        explanation: 'The Battle of Nalapani in October 1814 marked the beginning of the Anglo-Nepal War.',
      ),
      Question(
        id: 'hist_11',
        categoryId: 'history',
        text: 'Who was known as "Living Martyr" in Nepal\'s democracy movement?',
        options: ['Ganesh Man Singh', 'Krishna Prasad Bhattarai', 'B.P. Koirala', 'Manmohan Adhikari'],
        correctAnswerIndex: 0,
        explanation: 'Ganesh Man Singh is known as the "Living Martyr" of Nepal\'s democracy movement.',
      ),
      Question(
        id: 'hist_12',
        categoryId: 'history',
        text: 'When was the Interim Constitution of Nepal 2007 promulgated?',
        options: ['January 15, 2007', 'April 10, 2007', 'June 18, 2007', 'December 28, 2007'],
        correctAnswerIndex: 0,
        explanation: 'The Interim Constitution was promulgated on January 15, 2007.',
      ),
      Question(
        id: 'hist_13',
        categoryId: 'history',
        text: 'Who was the first President of Nepal?',
        options: ['Ram Baran Yadav', 'Dr. Rambaran Yadav', 'Bidya Devi Bhandari', 'Krishna Prasad Bhattarai'],
        correctAnswerIndex: 0,
        explanation: 'Dr. Ram Baran Yadav was the first President of Nepal.',
      ),
      Question(
        id: 'hist_14',
        categoryId: 'history',
        text: 'When was the monarchy abolished in Nepal?',
        options: ['2006', '2007', '2008', '2009'],
        correctAnswerIndex: 2,
        explanation: 'The monarchy was abolished on May 28, 2008.',
      ),
      Question(
        id: 'hist_15',
        categoryId: 'history',
        text: 'Who was the last King of Nepal?',
        options: ['King Birendra', 'King Gyanendra', 'King Dipendra', 'King Tribhuvan'],
        correctAnswerIndex: 1,
        explanation: 'King Gyanendra was the last King of Nepal.',
      ),
      // Adding 35 more history questions...
      Question(
        id: 'hist_16',
        categoryId: 'history',
        text: 'Which Malla king built the Krishna Mandir in Patan?',
        options: ['Siddhi Narsingh Malla', 'Yoga Narendra Malla', 'Sri Nivas Malla', 'Bhupatindra Malla'],
        correctAnswerIndex: 0,
        explanation: 'Siddhi Narsingh Malla built Krishna Mandir in 1637 AD.',
      ),
      Question(
        id: 'hist_17',
        categoryId: 'history',
        text: 'When was the Nepal-Britain Treaty of Peace and Friendship signed?',
        options: ['1920', '1923', '1925', '1927'],
        correctAnswerIndex: 1,
        explanation: 'The treaty was signed on December 21, 1923.',
      ),
      Question(
        id: 'hist_18',
        categoryId: 'history',
        text: 'Who founded the city of Kathmandu?',
        options: ['Gunakamadev', 'Manadev', 'Amshuverma', 'Jayastithi Malla'],
        correctAnswerIndex: 0,
        explanation: 'King Gunakamadev founded Kathmandu in 723 AD.',
      ),
      Question(
        id: 'hist_19',
        categoryId: 'history',
        text: 'When was the Gorkha Kingdom established?',
        options: ['1559', '1600', '1650', '1700'],
        correctAnswerIndex: 0,
        explanation: 'The Gorkha Kingdom was established in 1559 by Dravya Shah.',
      ),
      Question(
        id: 'hist_20',
        categoryId: 'history',
        text: 'Who built the Taleju Temple in Kathmandu?',
        options: ['Mahendra Malla', 'Pratap Malla', 'Jayaprakash Malla', 'Ranajit Malla'],
        correctAnswerIndex: 0,
        explanation: 'Mahendra Malla built the Taleju Temple in 1564 AD.',
      ),
      Question(
        id: 'hist_21',
        categoryId: 'history',
        text: 'When was the first written constitution of Nepal promulgated?',
        options: ['1948', '1951', '1959', '1962'],
        correctAnswerIndex: 0,
        explanation: 'The first written constitution was promulgated in 1948.',
      ),
      Question(
        id: 'hist_22',
        categoryId: 'history',
        text: 'Who was the first Nepali to climb Mount Everest?',
        options: ['Tenzing Norgay', 'Babu Chiri Sherpa', 'Ang Rita Sherpa', 'Apa Sherpa'],
        correctAnswerIndex: 0,
        explanation: 'Tenzing Norgay was the first Nepali to climb Mount Everest in 1953.',
      ),
      Question(
        id: 'hist_23',
        categoryId: 'history',
        text: 'When was the Nepali Congress party founded?',
        options: ['1947', '1950', '1951', '1952'],
        correctAnswerIndex: 1,
        explanation: 'Nepali Congress was founded on April 9, 1950.',
      ),
      Question(
        id: 'hist_24',
        categoryId: 'history',
        text: 'Who designed the current flag of Nepal?',
        options: ['Shankar Nath Rimal', 'King Prithvi Narayan Shah', 'Bhimsen Thapa', 'Bala Nanda Poudel'],
        correctAnswerIndex: 0,
        explanation: 'Shankar Nath Rimal designed the current flag.',
      ),
      Question(
        id: 'hist_25',
        categoryId: 'history',
        text: 'When was the first census conducted in Nepal?',
        options: ['1911', '1920', '1930', '1941'],
        correctAnswerIndex: 0,
        explanation: 'The first census was conducted in 1911 during the Rana period.',
      ),
      Question(
        id: 'hist_26',
        categoryId: 'history',
        text: 'Who was the first woman minister of Nepal?',
        options: ['Dwarika Devi Thakurani', 'Sahana Pradhan', 'Shailaja Acharya', 'Bidya Devi Bhandari'],
        correctAnswerIndex: 0,
        explanation: 'Dwarika Devi Thakurani was the first woman minister in 1959.',
      ),
      Question(
        id: 'hist_27',
        categoryId: 'history',
        text: 'When was the Muluki Ain (Civil Code) introduced?',
        options: ['1853', '1863', '1873', '1883'],
        correctAnswerIndex: 1,
        explanation: 'The Muluki Ain was introduced in 1863 by Jung Bahadur Rana.',
      ),
      Question(
        id: 'hist_28',
        categoryId: 'history',
        text: 'Who established the first college in Nepal?',
        options: ['Jung Bahadur Rana', 'Chandra Shumsher', 'Tri-Chandra College', 'Durbar High School'],
        correctAnswerIndex: 2,
        explanation: 'Tri-Chandra College was established in 1918 by Chandra Shumsher.',
      ),
      Question(
        id: 'hist_29',
        categoryId: 'history',
        text: 'When was the first newspaper published in Nepal?',
        options: ['1851', '1877', '1901', '1921'],
        correctAnswerIndex: 2,
        explanation: 'Gorkhapatra, the first newspaper, was published in 1901.',
      ),
      Question(
        id: 'hist_30',
        categoryId: 'history',
        text: 'Who built the Rani Pokhari?',
        options: ['Pratap Malla', 'Jung Bahadur Rana', 'Chandra Shumsher', 'King Birendra'],
        correctAnswerIndex: 0,
        explanation: 'Rani Pokhari was built by King Pratap Malla in 1670.',
      ),
      Question(
        id: 'hist_31',
        categoryId: 'history',
        text: 'When was Nepal admitted to the United Nations?',
        options: ['1955', '1958', '1960', '1962'],
        correctAnswerIndex: 0,
        explanation: 'Nepal was admitted to the UN on December 14, 1955.',
      ),
      Question(
        id: 'hist_32',
        categoryId: 'history',
        text: 'Who was the first Chief Justice of Nepal?',
        options: ['Bishwanath Upadhyaya', 'Hari Prasad Pradhan', 'Surya Prasad Upadhyaya', 'Krishna Prasad Upadhyaya'],
        correctAnswerIndex: 1,
        explanation: 'Hari Prasad Pradhan was the first Chief Justice (1951-1956).',
      ),
      Question(
        id: 'hist_33',
        categoryId: 'history',
        text: 'When was the first five-year plan implemented in Nepal?',
        options: ['1956', '1960', '1965', '1970'],
        correctAnswerIndex: 0,
        explanation: 'The first five-year plan was implemented from 1956 to 1961.',
      ),
      Question(
        id: 'hist_34',
        categoryId: 'history',
        text: 'Who established the first bank in Nepal?',
        options: ['Nepal Bank Ltd', 'Rastriya Banijya Bank', 'Nabil Bank', 'Standard Chartered'],
        correctAnswerIndex: 0,
        explanation: 'Nepal Bank Ltd was established in 1937.',
      ),
      Question(
        id: 'hist_35',
        categoryId: 'history',
        text: 'When was the National Anthem of Nepal adopted?',
        options: ['1962', '1970', '1975', '2007'],
        correctAnswerIndex: 0,
        explanation: 'The current national anthem was adopted in 1962.',
      ),
      Question(
        id: 'hist_36',
        categoryId: 'history',
        text: 'Who wrote the national anthem of Nepal?',
        options: ['Byakul Maila', 'Chakrapani Chalise', 'Laxmi Prasad Devkota', 'Bhanubhakta Acharya'],
        correctAnswerIndex: 0,
        explanation: 'Byakul Maila wrote the lyrics of the national anthem.',
      ),
      Question(
        id: 'hist_37',
        categoryId: 'history',
        text: 'When was Tribhuvan University established?',
        options: ['1959', '1962', '1965', '1970'],
        correctAnswerIndex: 0,
        explanation: 'Tribhuvan University was established in 1959.',
      ),
      Question(
        id: 'hist_38',
        categoryId: 'history',
        text: 'Who was the first Nepali to receive a PhD?',
        options: ['Kul Ratna Tuladhar', 'Dr. Harka Gurung', 'Dr. Triratna Manandhar', 'Dr. Tanka Prasad Acharya'],
        correctAnswerIndex: 0,
        explanation: 'Kul Ratna Tuladhar was the first Nepali to receive a PhD (from London University).',
      ),
      Question(
        id: 'hist_39',
        categoryId: 'history',
        text: 'When was the first hydroelectricity project built in Nepal?',
        options: ['1911', '1922', '1934', '1945'],
        correctAnswerIndex: 0,
        explanation: 'Pharping Hydroelectricity Project was built in 1911.',
      ),
      Question(
        id: 'hist_40',
        categoryId: 'history',
        text: 'Who built the Singha Durbar?',
        options: ['Chandra Shumsher', 'Jung Bahadur Rana', 'Bir Shumsher', 'Dev Shumsher'],
        correctAnswerIndex: 0,
        explanation: 'Singha Durbar was built by Chandra Shumsher in 1907.',
      ),
      Question(
        id: 'hist_41',
        categoryId: 'history',
        text: 'When was the first radio broadcast in Nepal?',
        options: ['1947', '1951', '1957', '1960'],
        correctAnswerIndex: 1,
        explanation: 'Radio Nepal began broadcasting on April 2, 1951.',
      ),
      Question(
        id: 'hist_42',
        categoryId: 'history',
        text: 'Who was the first female pilot of Nepal?',
        options: ['Anuradha Koirala', 'Bidya Devi Bhandari', 'Renu Kumari Yadav', 'Neerja Bhanot'],
        correctAnswerIndex: 2,
        explanation: 'Renu Kumari Yadav was the first female commercial pilot.',
      ),
      Question(
        id: 'hist_43',
        categoryId: 'history',
        text: 'When was the first television broadcast in Nepal?',
        options: ['1982', '1985', '1990', '1995'],
        correctAnswerIndex: 1,
        explanation: 'Nepal Television began broadcasting on December 29, 1985.',
      ),
      Question(
        id: 'hist_44',
        categoryId: 'history',
        text: 'Who established the first hospital in Nepal?',
        options: ['Bir Hospital', 'Patan Hospital', 'Teaching Hospital', 'Military Hospital'],
        correctAnswerIndex: 0,
        explanation: 'Bir Hospital was established in 1889 by Bir Shumsher.',
      ),
      Question(
        id: 'hist_45',
        categoryId: 'history',
        text: 'When was the first telephone line installed in Nepal?',
        options: ['1910', '1920', '1930', '1940'],
        correctAnswerIndex: 0,
        explanation: 'The first telephone line was installed in 1910 between Kathmandu and Bhaktapur.',
      ),
      Question(
        id: 'hist_46',
        categoryId: 'history',
        text: 'Who was the first Nepali to win an Olympic medal?',
        options: ['Bhim Bahadur Deuba', 'Tara Bahadur Gurung', 'No Nepali has won', 'Bidhan Lama'],
        correctAnswerIndex: 2,
        explanation: 'No Nepali athlete has won an Olympic medal yet.',
      ),
      Question(
        id: 'hist_47',
        categoryId: 'history',
        text: 'When was the first airline company established in Nepal?',
        options: ['1949', '1955', '1958', '1960'],
        correctAnswerIndex: 2,
        explanation: 'Royal Nepal Airlines was established in 1958.',
      ),
      Question(
        id: 'hist_48',
        categoryId: 'history',
        text: 'Who was the first female Chief Justice of Nepal?',
        options: ['Sushila Karki', 'Anup Raj Sharma', 'Kalyan Shrestha', 'Gopal Parajuli'],
        correctAnswerIndex: 0,
        explanation: 'Sushila Karki was the first female Chief Justice (2016-2017).',
      ),
      Question(
        id: 'hist_49',
        categoryId: 'history',
        text: 'When was the first stock exchange established in Nepal?',
        options: ['1976', '1984', '1993', '2000'],
        correctAnswerIndex: 1,
        explanation: 'Nepal Stock Exchange was established in 1984.',
      ),
      Question(
        id: 'hist_50',
        categoryId: 'history',
        text: 'Who was the first foreigner to climb Mount Everest?',
        options: ['Sir Edmund Hillary', 'Reinhold Messner', 'Junko Tabei', 'George Mallory'],
        correctAnswerIndex: 0,
        explanation: 'Sir Edmund Hillary was the first foreigner to climb Everest in 1953 with Tenzing Norgay.',
      ),
    ];
  }

  // Current Affairs Questions (50 questions)
  static List<Question> _getCurrentAffairsQuestions() {
    return [
      Question(
        id: 'curr_1',
        categoryId: 'current_affairs',
        text: 'Who is the current President of Nepal?',
        options: ['Bidya Devi Bhandari', 'Ram Chandra Poudel', 'Puspa Kamal Dahal', 'Sher Bahadur Deuba'],
        correctAnswerIndex: 1,
        explanation: 'Ram Chandra Poudel is the current President of Nepal (as of 2023).',
      ),
      Question(
        id: 'curr_2',
        categoryId: 'current_affairs',
        text: 'Who is the current Prime Minister of Nepal?',
        options: ['K.P. Sharma Oli', 'Sher Bahadur Deuba', 'Puspa Kamal Dahal', 'Madhav Kumar Nepal'],
        correctAnswerIndex: 2,
        explanation: 'Puspa Kamal Dahal (Prachanda) is the current Prime Minister.',
      ),
      Question(
        id: 'curr_3',
        categoryId: 'current_affairs',
        text: 'Which district was declared fully literate first in Nepal?',
        options: ['Kathmandu', 'Kaski', 'Bhaktapur', 'Lalitpur'],
        correctAnswerIndex: 1,
        explanation: 'Kaski district was declared fully literate in 2015.',
      ),
      Question(
        id: 'curr_4',
        categoryId: 'current_affairs',
        text: 'When was Nepal declared a Federal Democratic Republic?',
        options: ['2006', '2007', '2008', '2009'],
        correctAnswerIndex: 2,
        explanation: 'Nepal was declared a Federal Democratic Republic on May 28, 2008.',
      ),
      Question(
        id: 'curr_5',
        categoryId: 'current_affairs',
        text: 'What is the current minimum wage in Nepal?',
        options: ['Rs. 13,450', 'Rs. 15,000', 'Rs. 16,000', 'Rs. 17,300'],
        correctAnswerIndex: 3,
        explanation: 'The minimum wage is Rs. 17,300 per month (as of 2023).',
      ),
      Question(
        id: 'curr_6',
        categoryId: 'current_affairs',
        text: 'Which country is the largest foreign employment destination for Nepali workers?',
        options: ['Qatar', 'Malaysia', 'Saudi Arabia', 'UAE'],
        correctAnswerIndex: 1,
        explanation: 'Malaysia is the largest destination for Nepali migrant workers.',
      ),
      Question(
        id: 'curr_7',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s rank in the Human Development Index 2022?',
        options: ['142', '146', '150', '154'],
        correctAnswerIndex: 0,
        explanation: 'Nepal ranks 142nd in HDI 2022.',
      ),
      Question(
        id: 'curr_8',
        categoryId: 'current_affairs',
        text: 'When was the Constitution of Nepal 2072 promulgated?',
        options: ['September 20, 2015', 'October 20, 2015', 'November 20, 2015', 'December 20, 2015'],
        correctAnswerIndex: 0,
        explanation: 'The constitution was promulgated on September 20, 2015.',
      ),
      Question(
        id: 'curr_9',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s GDP growth rate for fiscal year 2022/23?',
        options: ['1.9%', '2.4%', '3.1%', '4.2%'],
        correctAnswerIndex: 0,
        explanation: 'Nepal\'s GDP growth was 1.9% in FY 2022/23.',
      ),
      Question(
        id: 'curr_10',
        categoryId: 'current_affairs',
        text: 'Which is the most populated province in Nepal?',
        options: ['Province 1', 'Province 2', 'Bagmati Province', 'Lumbini Province'],
        correctAnswerIndex: 1,
        explanation: 'Province 2 (Madhesh) is the most populated province.',
      ),
      Question(
        id: 'curr_11',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s inflation rate in 2023?',
        options: ['6.1%', '7.4%', '8.2%', '9.5%'],
        correctAnswerIndex: 1,
        explanation: 'Nepal\'s inflation rate was 7.4% in 2023.',
      ),
      Question(
        id: 'curr_12',
        categoryId: 'current_affairs',
        text: 'When was the Nepal Investment Summit 2023 held?',
        options: ['March 28-29', 'April 10-11', 'May 15-16', 'June 20-21'],
        correctAnswerIndex: 0,
        explanation: 'Nepal Investment Summit was held on March 28-29, 2023.',
      ),
      Question(
        id: 'curr_13',
        categoryId: 'current_affairs',
        text: 'Which country is Nepal\'s largest trade partner?',
        options: ['India', 'China', 'USA', 'Bangladesh'],
        correctAnswerIndex: 0,
        explanation: 'India is Nepal\'s largest trade partner.',
      ),
      Question(
        id: 'curr_14',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s foreign exchange reserve position in 2023?',
        options: ['USD 8.5 billion', 'USD 9.2 billion', 'USD 10.1 billion', 'USD 11.3 billion'],
        correctAnswerIndex: 1,
        explanation: 'Nepal\'s forex reserves were USD 9.2 billion in 2023.',
      ),
      Question(
        id: 'curr_15',
        categoryId: 'current_affairs',
        text: 'When was the MCC Compact signed by Nepal?',
        options: ['2017', '2018', '2019', '2020'],
        correctAnswerIndex: 0,
        explanation: 'The MCC Compact was signed in 2017.',
      ),
      // Adding 35 more current affairs questions...
      Question(
        id: 'curr_16',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s population according to 2021 census?',
        options: ['28.6 million', '29.1 million', '30.2 million', '31.5 million'],
        correctAnswerIndex: 1,
        explanation: 'Nepal\'s population is 29.1 million (2021 census).',
      ),
      Question(
        id: 'curr_17',
        categoryId: 'current_affairs',
        text: 'Which province has the highest literacy rate?',
        options: ['Bagmati', 'Gandaki', 'Karnali', 'Sudurpaschim'],
        correctAnswerIndex: 0,
        explanation: 'Bagmati Province has the highest literacy rate at 74%.',
      ),
      Question(
        id: 'curr_18',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s life expectancy at birth?',
        options: ['68 years', '71 years', '74 years', '77 years'],
        correctAnswerIndex: 1,
        explanation: 'Life expectancy in Nepal is 71 years (2023).',
      ),
      Question(
        id: 'curr_19',
        categoryId: 'current_affairs',
        text: 'Which is the largest political party in Nepal by seats in Parliament?',
        options: ['Nepali Congress', 'CPN-UML', 'Maoist Center', 'RSP'],
        correctAnswerIndex: 0,
        explanation: 'Nepali Congress has the most seats in Parliament.',
      ),
      Question(
        id: 'curr_20',
        categoryId: 'current_affairs',
        text: 'When was the local level election 2022 held?',
        options: ['May 13', 'June 28', 'July 17', 'August 5'],
        correctAnswerIndex: 0,
        explanation: 'Local elections were held on May 13, 2022.',
      ),
      Question(
        id: 'curr_21',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s rank in Global Peace Index 2023?',
        options: ['79', '84', '91', '96'],
        correctAnswerIndex: 2,
        explanation: 'Nepal ranks 91st in Global Peace Index 2023.',
      ),
      Question(
        id: 'curr_22',
        categoryId: 'current_affairs',
        text: 'Which is the most visited national park in Nepal?',
        options: ['Chitwan National Park', 'Sagarmatha National Park', 'Bardiya National Park', 'Langtang National Park'],
        correctAnswerIndex: 0,
        explanation: 'Chitwan National Park receives the most visitors.',
      ),
      Question(
        id: 'curr_23',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s total foreign debt in 2023?',
        options: ['USD 8.5 billion', 'USD 10.2 billion', 'USD 12.7 billion', 'USD 15.3 billion'],
        correctAnswerIndex: 1,
        explanation: 'Nepal\'s foreign debt is USD 10.2 billion (2023).',
      ),
      Question(
        id: 'curr_24',
        categoryId: 'current_affairs',
        text: 'When was the Visit Nepal 2020 campaign launched?',
        options: ['2018', '2019', '2020', '2021'],
        correctAnswerIndex: 0,
        explanation: 'Visit Nepal 2020 was launched in 2018.',
      ),
      Question(
        id: 'curr_25',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s unemployment rate in 2023?',
        options: ['4.5%', '5.2%', '6.1%', '7.3%'],
        correctAnswerIndex: 2,
        explanation: 'Unemployment rate is 6.1% (2023).',
      ),
      Question(
        id: 'curr_26',
        categoryId: 'current_affairs',
        text: 'Which is the largest source of foreign currency for Nepal?',
        options: ['Tourism', 'Remittance', 'Export', 'Foreign Aid'],
        correctAnswerIndex: 1,
        explanation: 'Remittance is the largest source of foreign currency.',
      ),
      Question(
        id: 'curr_27',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s ranking in Corruption Perception Index 2022?',
        options: ['110', '117', '124', '131'],
        correctAnswerIndex: 0,
        explanation: 'Nepal ranks 110th in CPI 2022.',
      ),
      Question(
        id: 'curr_28',
        categoryId: 'current_affairs',
        text: 'When was the Pokhara International Airport inaugurated?',
        options: ['January 1, 2023', 'March 10, 2023', 'May 15, 2023', 'July 1, 2023'],
        correctAnswerIndex: 0,
        explanation: 'Pokhara International Airport was inaugurated on January 1, 2023.',
      ),
      Question(
        id: 'curr_29',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s target year to graduate from LDC status?',
        options: ['2024', '2026', '2028', '2030'],
        correctAnswerIndex: 1,
        explanation: 'Nepal aims to graduate from LDC status by 2026.',
      ),
      Question(
        id: 'curr_30',
        categoryId: 'current_affairs',
        text: 'Which is the fastest growing sector in Nepal?',
        options: ['Agriculture', 'Tourism', 'Information Technology', 'Hydropower'],
        correctAnswerIndex: 2,
        explanation: 'Information Technology is the fastest growing sector.',
      ),
      Question(
        id: 'curr_31',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s position in Climate Change Vulnerability Index?',
        options: ['4th', '10th', '14th', '20th'],
        correctAnswerIndex: 0,
        explanation: 'Nepal is the 4th most vulnerable country to climate change.',
      ),
      Question(
        id: 'curr_32',
        categoryId: 'current_affairs',
        text: 'When was the Gautam Buddha International Airport inaugurated?',
        options: ['May 16, 2022', 'July 1, 2022', 'September 15, 2022', 'November 20, 2022'],
        correctAnswerIndex: 0,
        explanation: 'GBIA was inaugurated on May 16, 2022.',
      ),
      Question(
        id: 'curr_33',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s internet penetration rate?',
        options: ['65%', '72%', '78%', '85%'],
        correctAnswerIndex: 1,
        explanation: 'Internet penetration is 72% (2023).',
      ),
      Question(
        id: 'curr_34',
        categoryId: 'current_affairs',
        text: 'Which is the largest export item of Nepal?',
        options: ['Carpet', 'Garments', 'Tea', 'Cardamom'],
        correctAnswerIndex: 0,
        explanation: 'Carpet is the largest export item.',
      ),
      Question(
        id: 'curr_35',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s position in World Happiness Report 2023?',
        options: ['78', '84', '91', '96'],
        correctAnswerIndex: 2,
        explanation: 'Nepal ranks 91st in World Happiness Report 2023.',
      ),
      Question(
        id: 'curr_36',
        categoryId: 'current_affairs',
        text: 'When was the National Payment Switch (NPS) launched?',
        options: ['2019', '2020', '2021', '2022'],
        correctAnswerIndex: 3,
        explanation: 'NPS was launched in 2022.',
      ),
      Question(
        id: 'curr_37',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s mobile phone penetration rate?',
        options: ['105%', '115%', '125%', '135%'],
        correctAnswerIndex: 3,
        explanation: 'Mobile penetration is 135% (multiple SIMs per person).',
      ),
      Question(
        id: 'curr_38',
        categoryId: 'current_affairs',
        text: 'Which province has the highest poverty rate?',
        options: ['Karnali', 'Sudurpaschim', 'Province 2', 'Gandaki'],
        correctAnswerIndex: 0,
        explanation: 'Karnali Province has the highest poverty rate at 28%.',
      ),
      Question(
        id: 'curr_39',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s tax-to-GDP ratio?',
        options: ['15.2%', '18.5%', '21.3%', '23.7%'],
        correctAnswerIndex: 1,
        explanation: 'Tax-to-GDP ratio is 18.5% (2023).',
      ),
      Question(
        id: 'curr_40',
        categoryId: 'current_affairs',
        text: 'When was the Digital Nepal Framework launched?',
        options: ['2019', '2020', '2021', '2022'],
        correctAnswerIndex: 0,
        explanation: 'Digital Nepal Framework was launched in 2019.',
      ),
      Question(
        id: 'curr_41',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s position in Gender Inequality Index?',
        options: ['105', '115', '124', '131'],
        correctAnswerIndex: 1,
        explanation: 'Nepal ranks 115th in Gender Inequality Index.',
      ),
      Question(
        id: 'curr_42',
        categoryId: 'current_affairs',
        text: 'Which is the largest bank in Nepal by assets?',
        options: ['Nabil Bank', 'NIC Asia Bank', 'Rastriya Banijya Bank', 'Global IME Bank'],
        correctAnswerIndex: 2,
        explanation: 'Rastriya Banijya Bank is the largest by assets.',
      ),
      Question(
        id: 'curr_43',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s position in Ease of Doing Business 2020?',
        options: ['94', '110', '123', '137'],
        correctAnswerIndex: 0,
        explanation: 'Nepal ranks 94th in Ease of Doing Business.',
      ),
      Question(
        id: 'curr_44',
        categoryId: 'current_affairs',
        text: 'When was the Nepal-China Transit Transport Agreement signed?',
        options: ['2016', '2018', '2020', '2022'],
        correctAnswerIndex: 1,
        explanation: 'The agreement was signed in 2018.',
      ),
      Question(
        id: 'curr_45',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s position in Global Hunger Index 2022?',
        options: ['69', '76', '81', '87'],
        correctAnswerIndex: 1,
        explanation: 'Nepal ranks 76th in Global Hunger Index 2022.',
      ),
      Question(
        id: 'curr_46',
        categoryId: 'current_affairs',
        text: 'Which is the largest hydropower project in Nepal?',
        options: ['Upper Tamakoshi', 'Kaligandaki', 'Marsyangdi', 'Middle Marsyangdi'],
        correctAnswerIndex: 0,
        explanation: 'Upper Tamakoshi (456 MW) is the largest.',
      ),
      Question(
        id: 'curr_47',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s position in Environmental Performance Index?',
        options: ['145', '152', '160', '168'],
        correctAnswerIndex: 1,
        explanation: 'Nepal ranks 152nd in Environmental Performance Index.',
      ),
      Question(
        id: 'curr_48',
        categoryId: 'current_affairs',
        text: 'When was the Nepal-India petroleum pipeline inaugurated?',
        options: ['2019', '2020', '2021', '2022'],
        correctAnswerIndex: 0,
        explanation: 'The pipeline was inaugurated in 2019.',
      ),
      Question(
        id: 'curr_49',
        categoryId: 'current_affairs',
        text: 'What is Nepal\'s position in Global Innovation Index 2022?',
        options: ['108', '111', '116', '121'],
        correctAnswerIndex: 3,
        explanation: 'Nepal ranks 121st in Global Innovation Index 2022.',
      ),
      Question(
        id: 'curr_50',
        categoryId: 'current_affairs',
        text: 'Which is the largest university in Nepal by student enrollment?',
        options: ['Tribhuvan University', 'Kathmandu University', 'Pokhara University', 'Purwanchal University'],
        correctAnswerIndex: 0,
        explanation: 'Tribhuvan University has over 400,000 students.',
      ),
    ];
  }

  // Mathematics Questions (50 questions)
  static List<Question> _getMathematicsQuestions() {
    return [
      Question(
        id: 'math_1',
        categoryId: 'mathematics',
        text: 'What is 15% of 200?',
        options: ['20', '30', '40', '50'],
        correctAnswerIndex: 1,
        explanation: '15% of 200 = (15/100) × 200 = 30',
      ),
      Question(
        id: 'math_2',
        categoryId: 'mathematics',
        text: 'If 2x + 5 = 15, what is the value of x?',
        options: ['5', '6', '7', '8'],
        correctAnswerIndex: 0,
        explanation: '2x + 5 = 15 → 2x = 10 → x = 5',
      ),
      Question(
        id: 'math_3',
        categoryId: 'mathematics',
        text: 'What is the square root of 144?',
        options: ['10', '11', '12', '13'],
        correctAnswerIndex: 2,
        explanation: '12 × 12 = 144, so √144 = 12',
      ),
      Question(
        id: 'math_4',
        categoryId: 'mathematics',
        text: 'If a triangle has angles of 45° and 55°, what is the third angle?',
        options: ['60°', '70°', '80°', '90°'],
        correctAnswerIndex: 2,
        explanation: 'Sum of angles = 180°. Third angle = 180 - (45 + 55) = 80°',
      ),
      Question(
        id: 'math_5',
        categoryId: 'mathematics',
        text: 'What is 3/4 expressed as a percentage?',
        options: ['65%', '70%', '75%', '80%'],
        correctAnswerIndex: 2,
        explanation: '3/4 = 0.75 = 75%',
      ),
      Question(
        id: 'math_6',
        categoryId: 'mathematics',
        text: 'If a rectangle has length 8 cm and width 5 cm, what is its area?',
        options: ['30 cm²', '35 cm²', '40 cm²', '45 cm²'],
        correctAnswerIndex: 2,
        explanation: 'Area = length × width = 8 × 5 = 40 cm²',
      ),
      Question(
        id: 'math_7',
        categoryId: 'mathematics',
        text: 'What is the next number in the sequence: 2, 4, 8, 16, ?',
        options: ['24', '28', '32', '36'],
        correctAnswerIndex: 2,
        explanation: 'Each number doubles the previous: 2×2=4, 4×2=8, 8×2=16, 16×2=32',
      ),
      Question(
        id: 'math_8',
        categoryId: 'mathematics',
        text: 'Simplify: (3 + 5) × 2 - 4',
        options: ['10', '12', '14', '16'],
        correctAnswerIndex: 1,
        explanation: '(3 + 5) × 2 - 4 = 8 × 2 - 4 = 16 - 4 = 12',
      ),
      Question(
        id: 'math_9',
        categoryId: 'mathematics',
        text: 'What is the average of 10, 20, 30, and 40?',
        options: ['20', '25', '30', '35'],
        correctAnswerIndex: 1,
        explanation: 'Average = (10 + 20 + 30 + 40) ÷ 4 = 100 ÷ 4 = 25',
      ),
      Question(
        id: 'math_10',
        categoryId: 'mathematics',
        text: 'If 5 workers can complete a job in 12 days, how many days will 6 workers take?',
        options: ['8', '9', '10', '11'],
        correctAnswerIndex: 2,
        explanation: '5 workers × 12 days = 60 worker-days. 6 workers = 60 ÷ 6 = 10 days',
      ),
      Question(
        id: 'math_11',
        categoryId: 'mathematics',
        text: 'What is 25% of 1,000?',
        options: ['200', '250', '300', '350'],
        correctAnswerIndex: 1,
        explanation: '25% of 1000 = (25/100) × 1000 = 250',
      ),
      Question(
        id: 'math_12',
        categoryId: 'mathematics',
        text: 'If x² = 64, what is x?',
        options: ['6', '7', '8', '9'],
        correctAnswerIndex: 2,
        explanation: '8 × 8 = 64, so x = 8 (or -8)',
      ),
      Question(
        id: 'math_13',
        categoryId: 'mathematics',
        text: 'What is the perimeter of a square with side 7 cm?',
        options: ['21 cm', '28 cm', '35 cm', '42 cm'],
        correctAnswerIndex: 1,
        explanation: 'Perimeter = 4 × side = 4 × 7 = 28 cm',
      ),
      Question(
        id: 'math_14',
        categoryId: 'mathematics',
        text: 'Convert 0.75 to a fraction',
        options: ['1/2', '2/3', '3/4', '4/5'],
        correctAnswerIndex: 2,
        explanation: '0.75 = 75/100 = 3/4',
      ),
      Question(
        id: 'math_15',
        categoryId: 'mathematics',
        text: 'What is 12 × 11?',
        options: ['121', '132', '143', '154'],
        correctAnswerIndex: 1,
        explanation: '12 × 11 = 132',
      ),
      // Adding 35 more mathematics questions...
      Question(
        id: 'math_16',
        categoryId: 'mathematics',
        text: 'What is the value of π (pi) to two decimal places?',
        options: ['3.12', '3.14', '3.16', '3.18'],
        correctAnswerIndex: 1,
        explanation: 'π ≈ 3.14159, so to two decimal places it\'s 3.14',
      ),
      Question(
        id: 'math_17',
        categoryId: 'mathematics',
        text: 'If a car travels 240 km in 4 hours, what is its speed?',
        options: ['50 km/h', '55 km/h', '60 km/h', '65 km/h'],
        correctAnswerIndex: 2,
        explanation: 'Speed = Distance ÷ Time = 240 ÷ 4 = 60 km/h',
      ),
      Question(
        id: 'math_18',
        categoryId: 'mathematics',
        text: 'What is 7² + 8²?',
        options: ['100', '105', '110', '113'],
        correctAnswerIndex: 3,
        explanation: '7² = 49, 8² = 64, so 49 + 64 = 113',
      ),
      Question(
        id: 'math_19',
        categoryId: 'mathematics',
        text: 'If 30% of a number is 45, what is the number?',
        options: ['120', '130', '140', '150'],
        correctAnswerIndex: 3,
        explanation: 'Let the number be x. 0.3x = 45 → x = 45 ÷ 0.3 = 150',
      ),
      Question(
        id: 'math_20',
        categoryId: 'mathematics',
        text: 'What is the area of a circle with radius 7 cm? (π = 22/7)',
        options: ['144 cm²', '154 cm²', '164 cm²', '174 cm²'],
        correctAnswerIndex: 1,
        explanation: 'Area = πr² = (22/7) × 7 × 7 = 154 cm²',
      ),
      Question(
        id: 'math_21',
        categoryId: 'mathematics',
        text: 'Simplify: 12 ÷ 3 × 4 + 2',
        options: ['14', '16', '18', '20'],
        correctAnswerIndex: 2,
        explanation: '12 ÷ 3 × 4 + 2 = 4 × 4 + 2 = 16 + 2 = 18',
      ),
      Question(
        id: 'math_22',
        categoryId: 'mathematics',
        text: 'What is the greatest common factor of 24 and 36?',
        options: ['6', '8', '12', '16'],
        correctAnswerIndex: 2,
        explanation: 'Factors of 24: 1,2,3,4,6,8,12,24; Factors of 36: 1,2,3,4,6,9,12,18,36; GCF = 12',
      ),
      Question(
        id: 'math_23',
        categoryId: 'mathematics',
        text: 'If 5x - 3 = 22, what is x?',
        options: ['4', '5', '6', '7'],
        correctAnswerIndex: 1,
        explanation: '5x - 3 = 22 → 5x = 25 → x = 5',
      ),
      Question(
        id: 'math_24',
        categoryId: 'mathematics',
        text: 'What is the volume of a cube with side 5 cm?',
        options: ['100 cm³', '110 cm³', '120 cm³', '125 cm³'],
        correctAnswerIndex: 3,
        explanation: 'Volume = side³ = 5 × 5 × 5 = 125 cm³',
      ),
      Question(
        id: 'math_25',
        categoryId: 'mathematics',
        text: 'Convert 3/8 to a decimal',
        options: ['0.325', '0.350', '0.375', '0.400'],
        correctAnswerIndex: 2,
        explanation: '3 ÷ 8 = 0.375',
      ),
      Question(
        id: 'math_26',
        categoryId: 'mathematics',
        text: 'What is 15 × 15?',
        options: ['200', '215', '225', '250'],
        correctAnswerIndex: 2,
        explanation: '15 × 15 = 225',
      ),
      Question(
        id: 'math_27',
        categoryId: 'mathematics',
        text: 'If the ratio of boys to girls is 3:2 and there are 30 boys, how many girls are there?',
        options: ['15', '18', '20', '25'],
        correctAnswerIndex: 2,
        explanation: '3:2 = 30:x → 3/2 = 30/x → x = (30 × 2)/3 = 20',
      ),
      Question(
        id: 'math_28',
        categoryId: 'mathematics',
        text: 'What is 40% of 250?',
        options: ['80', '90', '100', '110'],
        correctAnswerIndex: 2,
        explanation: '40% of 250 = 0.4 × 250 = 100',
      ),
      Question(
        id: 'math_29',
        categoryId: 'mathematics',
        text: 'Find the missing number: 2, 5, 10, 17, ?',
        options: ['24', '26', '28', '30'],
        correctAnswerIndex: 1,
        explanation: 'Difference increases by 2: +3, +5, +7, +9 → 17 + 9 = 26',
      ),
      Question(
        id: 'math_30',
        categoryId: 'mathematics',
        text: 'What is the perimeter of a rectangle with length 12 cm and width 8 cm?',
        options: ['30 cm', '35 cm', '40 cm', '45 cm'],
        correctAnswerIndex: 2,
        explanation: 'Perimeter = 2 × (length + width) = 2 × (12 + 8) = 40 cm',
      ),
      Question(
        id: 'math_31',
        categoryId: 'mathematics',
        text: 'Solve: 2³ + 3²',
        options: ['13', '15', '17', '19'],
        correctAnswerIndex: 2,
        explanation: '2³ = 8, 3² = 9, so 8 + 9 = 17',
      ),
      Question(
        id: 'math_32',
        categoryId: 'mathematics',
        text: 'What is the least common multiple of 6 and 8?',
        options: ['12', '18', '24', '30'],
        correctAnswerIndex: 2,
        explanation: 'Multiples of 6: 6,12,18,24,30; Multiples of 8: 8,16,24,32; LCM = 24',
      ),
      Question(
        id: 'math_33',
        categoryId: 'mathematics',
        text: 'If 4x + 7 = 31, what is x?',
        options: ['4', '5', '6', '7'],
        correctAnswerIndex: 2,
        explanation: '4x + 7 = 31 → 4x = 24 → x = 6',
      ),
      Question(
        id: 'math_34',
        categoryId: 'mathematics',
        text: 'What is 1/2 + 1/3?',
        options: ['2/5', '3/5', '5/6', '7/6'],
        correctAnswerIndex: 2,
        explanation: '1/2 + 1/3 = 3/6 + 2/6 = 5/6',
      ),
      Question(
        id: 'math_35',
        categoryId: 'mathematics',
        text: 'A shop offers 20% discount on a Rs. 500 item. What is the sale price?',
        options: ['Rs. 400', 'Rs. 420', 'Rs. 440', 'Rs. 460'],
        correctAnswerIndex: 0,
        explanation: 'Discount = 20% of 500 = 100. Sale price = 500 - 100 = 400',
      ),
      Question(
        id: 'math_36',
        categoryId: 'mathematics',
        text: 'What is 144 ÷ 12?',
        options: ['10', '11', '12', '13'],
        correctAnswerIndex: 2,
        explanation: '144 ÷ 12 = 12',
      ),
      Question(
        id: 'math_37',
        categoryId: 'mathematics',
        text: 'If the area of a square is 81 cm², what is its perimeter?',
        options: ['27 cm', '32 cm', '36 cm', '40 cm'],
        correctAnswerIndex: 2,
        explanation: 'Side = √81 = 9 cm. Perimeter = 4 × 9 = 36 cm',
      ),
      Question(
        id: 'math_38',
        categoryId: 'mathematics',
        text: 'What is 0.125 as a fraction?',
        options: ['1/6', '1/7', '1/8', '1/9'],
        correctAnswerIndex: 2,
        explanation: '0.125 = 125/1000 = 1/8',
      ),
      Question(
        id: 'math_39',
        categoryId: 'mathematics',
        text: 'Find the average of first 5 prime numbers',
        options: ['5.0', '5.2', '5.6', '6.0'],
        correctAnswerIndex: 2,
        explanation: 'First 5 primes: 2,3,5,7,11. Average = (2+3+5+7+11)/5 = 28/5 = 5.6',
      ),
      Question(
        id: 'math_40',
        categoryId: 'mathematics',
        text: 'What is 25 × 24?',
        options: ['500', '550', '600', '650'],
        correctAnswerIndex: 2,
        explanation: '25 × 24 = 600',
      ),
      Question(
        id: 'math_41',
        categoryId: 'mathematics',
        text: 'If 2/5 of a number is 30, what is the number?',
        options: ['60', '65', '70', '75'],
        correctAnswerIndex: 3,
        explanation: '(2/5)x = 30 → x = 30 × (5/2) = 75',
      ),
      Question(
        id: 'math_42',
        categoryId: 'mathematics',
        text: 'What is the circumference of a circle with diameter 14 cm? (π = 22/7)',
        options: ['38 cm', '40 cm', '42 cm', '44 cm'],
        correctAnswerIndex: 3,
        explanation: 'Circumference = πd = (22/7) × 14 = 44 cm',
      ),
      Question(
        id: 'math_43',
        categoryId: 'mathematics',
        text: 'Solve: 100 - 45 ÷ 5 + 3',
        options: ['92', '94', '96', '98'],
        correctAnswerIndex: 1,
        explanation: '100 - 45 ÷ 5 + 3 = 100 - 9 + 3 = 94',
      ),
      Question(
        id: 'math_44',
        categoryId: 'mathematics',
        text: 'What is the square of 25?',
        options: ['525', '575', '625', '675'],
        correctAnswerIndex: 2,
        explanation: '25² = 625',
      ),
      Question(
        id: 'math_45',
        categoryId: 'mathematics',
        text: 'If 3 pens cost Rs. 45, how much will 7 pens cost?',
        options: ['Rs. 95', 'Rs. 100', 'Rs. 105', 'Rs. 110'],
        correctAnswerIndex: 2,
        explanation: '1 pen = 45/3 = Rs. 15. 7 pens = 7 × 15 = Rs. 105',
      ),
      Question(
        id: 'math_46',
        categoryId: 'mathematics',
        text: 'What is 7/10 expressed as a percentage?',
        options: ['65%', '68%', '70%', '72%'],
        correctAnswerIndex: 2,
        explanation: '7/10 = 0.7 = 70%',
      ),
      Question(
        id: 'math_47',
        categoryId: 'mathematics',
        text: 'Find the missing number: 1, 4, 9, 16, ?',
        options: ['20', '23', '25', '28'],
        correctAnswerIndex: 2,
        explanation: 'These are squares: 1²=1, 2²=4, 3²=9, 4²=16, 5²=25',
      ),
      Question(
        id: 'math_48',
        categoryId: 'mathematics',
        text: 'What is 75% of 200?',
        options: ['125', '140', '150', '160'],
        correctAnswerIndex: 2,
        explanation: '75% of 200 = 0.75 × 200 = 150',
      ),
      Question(
        id: 'math_49',
        categoryId: 'mathematics',
        text: 'If a train travels 300 km in 5 hours, what is its speed in m/s?',
        options: ['15 m/s', '16.67 m/s', '18 m/s', '20 m/s'],
        correctAnswerIndex: 1,
        explanation: 'Speed = 300/5 = 60 km/h = 60 × (1000/3600) = 16.67 m/s',
      ),
      Question(
        id: 'math_50',
        categoryId: 'mathematics',
        text: 'What is √169?',
        options: ['11', '12', '13', '14'],
        correctAnswerIndex: 2,
        explanation: '13 × 13 = 169, so √169 = 13',
      ),
    ];
  }

  // Critical Thinking Questions (50 questions)
  static List<Question> _getCriticalThinkingQuestions() {
    return [
      Question(
        id: 'crit_1',
        categoryId: 'critical_thinking',
        text: 'If all roses are flowers and some flowers fade quickly, then:',
        options: [
          'All roses fade quickly',
          'Some roses fade quickly',
          'No roses fade quickly',
          'Some roses do not fade quickly'
        ],
        correctAnswerIndex: 1,
        explanation: 'Since all roses are flowers and some flowers fade quickly, it follows that some roses fade quickly.',
      ),
      Question(
        id: 'crit_2',
        categoryId: 'critical_thinking',
        text: 'What comes next in the series: A, C, E, G, ?',
        options: ['H', 'I', 'J', 'K'],
        correctAnswerIndex: 1,
        explanation: 'Series skips one letter: A, (skip B), C, (skip D), E, (skip F), G, (skip H), I',
      ),
      Question(
        id: 'crit_3',
        categoryId: 'critical_thinking',
        text: 'If some doctors are surgeons and all surgeons are specialists, then:',
        options: [
          'All doctors are specialists',
          'Some doctors are specialists',
          'No doctors are specialists',
          'All specialists are doctors'
        ],
        correctAnswerIndex: 1,
        explanation: 'Since some doctors are surgeons and all surgeons are specialists, it follows that some doctors are specialists.',
      ),
      Question(
        id: 'crit_4',
        categoryId: 'critical_thinking',
        text: 'Find the odd one out: Square, Circle, Triangle, Rectangle',
        options: ['Square', 'Circle', 'Triangle', 'Rectangle'],
        correctAnswerIndex: 1,
        explanation: 'Circle is the only non-polygon (no straight sides).',
      ),
      Question(
        id: 'crit_5',
        categoryId: 'critical_thinking',
        text: 'Complete the analogy: Bird is to Fly as Fish is to ?',
        options: ['Swim', 'Walk', 'Crawl', 'Jump'],
        correctAnswerIndex: 0,
        explanation: 'Birds fly, fish swim - both are primary modes of movement.',
      ),
      Question(
        id: 'crit_6',
        categoryId: 'critical_thinking',
        text: 'If today is Monday, what day will it be 100 days from now?',
        options: ['Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        correctAnswerIndex: 1,
        explanation: '100 ÷ 7 = 14 weeks remainder 2 days. Monday + 2 days = Wednesday',
      ),
      Question(
        id: 'crit_7',
        categoryId: 'critical_thinking',
        text: 'Which number should come next: 2, 6, 12, 20, 30, ?',
        options: ['40', '42', '44', '46'],
        correctAnswerIndex: 1,
        explanation: 'Difference increases by 2: +4, +6, +8, +10, +12 → 30 + 12 = 42',
      ),
      Question(
        id: 'crit_8',
        categoryId: 'critical_thinking',
        text: 'If no cats are dogs and some animals are cats, then:',
        options: [
          'All animals are dogs',
          'Some animals are not dogs',
          'No animals are dogs',
          'All dogs are animals'
        ],
        correctAnswerIndex: 1,
        explanation: 'Since some animals are cats and no cats are dogs, it follows that some animals (the cats) are not dogs.',
      ),
      Question(
        id: 'crit_9',
        categoryId: 'critical_thinking',
        text: 'Find the odd one out: Apple, Banana, Carrot, Orange',
        options: ['Apple', 'Banana', 'Carrot', 'Orange'],
        correctAnswerIndex: 2,
        explanation: 'Carrot is a vegetable while others are fruits.',
      ),
      Question(
        id: 'crit_10',
        categoryId: 'critical_thinking',
        text: 'Complete the analogy: Pen is to Write as Knife is to ?',
        options: ['Cut', 'Sharp', 'Metal', 'Tool'],
        correctAnswerIndex: 0,
        explanation: 'Pen is used to write, knife is used to cut.',
      ),
      Question(
        id: 'crit_11',
        categoryId: 'critical_thinking',
        text: 'If all As are Bs and all Bs are Cs, then:',
        options: [
          'All As are Cs',
          'Some As are not Cs',
          'No As are Cs',
          'Some Cs are not As'
        ],
        correctAnswerIndex: 0,
        explanation: 'If all As are Bs and all Bs are Cs, then all As must be Cs.',
      ),
      Question(
        id: 'crit_12',
        categoryId: 'critical_thinking',
        text: 'What is the missing number: 3, 8, 15, 24, 35, ?',
        options: ['46', '48', '50', '52'],
        correctAnswerIndex: 1,
        explanation: 'Difference increases by 2: +5, +7, +9, +11, +13 → 35 + 13 = 48',
      ),
      Question(
        id: 'crit_13',
        categoryId: 'critical_thinking',
        text: 'Find the odd one out: Mercury, Venus, Earth, Mars, Sun',
        options: ['Mercury', 'Venus', 'Earth', 'Sun'],
        correctAnswerIndex: 3,
        explanation: 'Sun is a star while others are planets.',
      ),
      Question(
        id: 'crit_14',
        categoryId: 'critical_thinking',
        text: 'Complete the analogy: Doctor is to Hospital as Teacher is to ?',
        options: ['School', 'Student', 'Class', 'Book'],
        correctAnswerIndex: 0,
        explanation: 'Doctor works in hospital, teacher works in school.',
      ),
      Question(
        id: 'crit_15',
        categoryId: 'critical_thinking',
        text: 'If some students are athletes and no athletes are lazy, then:',
        options: [
          'All students are lazy',
          'Some students are not lazy',
          'No students are lazy',
          'All lazy people are students'
        ],
        correctAnswerIndex: 1,
        explanation: 'Some students are athletes and no athletes are lazy, so those athlete students are not lazy.',
      ),
      // Adding 35 more critical thinking questions...
      Question(
        id: 'crit_16',
        categoryId: 'critical_thinking',
        text: 'Which letter comes next: B, D, G, K, ?',
        options: ['O', 'P', 'Q', 'R'],
        correctAnswerIndex: 1,
        explanation: 'Position difference increases: +2, +3, +4, +5 → K (11) + 5 = P (16)',
      ),
      Question(
        id: 'crit_17',
        categoryId: 'critical_thinking',
        text: 'Find the odd one out: January, March, July, November, December',
        options: ['January', 'March', 'July', 'December'],
        correctAnswerIndex: 3,
        explanation: 'December has 31 days but starts with "D" while others start with "J" or "M"',
      ),
      Question(
        id: 'crit_18',
        categoryId: 'critical_thinking',
        text: 'Complete: 2, 3, 5, 7, 11, 13, ?',
        options: ['15', '17', '19', '21'],
        correctAnswerIndex: 1,
        explanation: 'These are prime numbers. Next prime after 13 is 17.',
      ),
      Question(
        id: 'crit_19',
        categoryId: 'critical_thinking',
        text: 'If all politicians are public speakers and some public speakers are lawyers, then:',
        options: [
          'All politicians are lawyers',
          'Some politicians are lawyers',
          'No politicians are lawyers',
          'All lawyers are politicians'
        ],
        correctAnswerIndex: 1,
        explanation: 'Cannot determine that all politicians are lawyers, only that some might be.',
      ),
      Question(
        id: 'crit_20',
        categoryId: 'critical_thinking',
        text: 'Find the odd one out: Tiger, Lion, Leopard, Elephant, Cheetah',
        options: ['Tiger', 'Lion', 'Elephant', 'Cheetah'],
        correctAnswerIndex: 2,
        explanation: 'Elephant is not a big cat.',
      ),
      Question(
        id: 'crit_21',
        categoryId: 'critical_thinking',
        text: 'Complete the analogy: Ocean is to Water as Desert is to ?',
        options: ['Sand', 'Heat', 'Camel', 'Oasis'],
        correctAnswerIndex: 0,
        explanation: 'Ocean primarily consists of water, desert primarily consists of sand.',
      ),
      Question(
        id: 'crit_22',
        categoryId: 'critical_thinking',
        text: 'What comes next: Z, X, V, T, ?',
        options: ['R', 'S', 'Q', 'P'],
        correctAnswerIndex: 0,
        explanation: 'Alphabet skipping one letter backwards: Z, (skip Y), X, (skip W), V, (skip U), T, (skip S), R',
      ),
      Question(
        id: 'crit_23',
        categoryId: 'critical_thinking',
        text: 'If no birds are mammals and all bats are mammals, then:',
        options: [
          'Some bats are birds',
          'No bats are birds',
          'All birds are bats',
          'Some birds are mammals'
        ],
        correctAnswerIndex: 1,
        explanation: 'Since all bats are mammals and no birds are mammals, no bats can be birds.',
      ),
      Question(
        id: 'crit_24',
        categoryId: 'critical_thinking',
        text: 'Find the odd one out: Gold, Silver, Bronze, Iron, Platinum',
        options: ['Gold', 'Silver', 'Bronze', 'Iron'],
        correctAnswerIndex: 2,
        explanation: 'Bronze is an alloy while others are pure elements.',
      ),
      Question(
        id: 'crit_25',
        categoryId: 'critical_thinking',
        text: 'Complete: 1, 1, 2, 3, 5, 8, 13, ?',
        options: ['18', '20', '21', '24'],
        correctAnswerIndex: 2,
        explanation: 'Fibonacci sequence: each number is sum of previous two: 8 + 13 = 21',
      ),
      Question(
        id: 'crit_26',
        categoryId: 'critical_thinking',
        text: 'If some teachers are writers and all writers are creative, then:',
        options: [
          'All teachers are creative',
          'Some teachers are creative',
          'No teachers are creative',
          'All creative people are teachers'
        ],
        correctAnswerIndex: 1,
        explanation: 'Some teachers are writers and all writers are creative, so some teachers are creative.',
      ),
      Question(
        id: 'crit_27',
        categoryId: 'critical_thinking',
        text: 'Find the odd one out: Carrot, Potato, Tomato, Onion, Cabbage',
        options: ['Carrot', 'Potato', 'Tomato', 'Cabbage'],
        correctAnswerIndex: 2,
        explanation: 'Tomato is technically a fruit while others are vegetables.',
      ),
      Question(
        id: 'crit_28',
        categoryId: 'critical_thinking',
        text: 'Complete analogy: Keyboard is to Computer as Steering Wheel is to ?',
        options: ['Car', 'Driver', 'Road', 'Wheel'],
        correctAnswerIndex: 0,
        explanation: 'Keyboard controls computer, steering wheel controls car.',
      ),
      Question(
        id: 'crit_29',
        categoryId: 'critical_thinking',
        text: 'What comes next: 1, 4, 9, 16, 25, 36, ?',
        options: ['48', '49', '50', '52'],
        correctAnswerIndex: 1,
        explanation: 'Square numbers: 1², 2², 3², 4², 5², 6², 7² = 49',
      ),
      Question(
        id: 'crit_30',
        categoryId: 'critical_thinking',
        text: 'If all students study and some who study get good grades, then:',
        options: [
          'All students get good grades',
          'Some students get good grades',
          'No students get good grades',
          'Only students get good grades'
        ],
        correctAnswerIndex: 1,
        explanation: 'All students study and some who study get good grades, so some students get good grades.',
      ),
      Question(
        id: 'crit_31',
        categoryId: 'critical_thinking',
        text: 'Find odd one: Circle, Sphere, Cube, Cylinder, Cone',
        options: ['Circle', 'Sphere', 'Cube', 'Cylinder'],
        correctAnswerIndex: 0,
        explanation: 'Circle is 2D while others are 3D shapes.',
      ),
      Question(
        id: 'crit_32',
        categoryId: 'critical_thinking',
        text: 'Complete: 3, 9, 27, 81, ?',
        options: ['162', '243', '324', '405'],
        correctAnswerIndex: 1,
        explanation: 'Multiply by 3 each time: 3×3=9, 9×3=27, 27×3=81, 81×3=243',
      ),
      Question(
        id: 'crit_33',
        categoryId: 'critical_thinking',
        text: 'If no reptiles have fur and all snakes are reptiles, then:',
        options: [
          'All snakes have fur',
          'Some snakes have fur',
          'No snakes have fur',
          'Some reptiles are not snakes'
        ],
        correctAnswerIndex: 2,
        explanation: 'All snakes are reptiles and no reptiles have fur, so no snakes have fur.',
      ),
      Question(
        id: 'crit_34',
        categoryId: 'critical_thinking',
        text: 'Find odd one: Piano, Guitar, Violin, Flute, Drum',
        options: ['Piano', 'Guitar', 'Flute', 'Drum'],
        correctAnswerIndex: 3,
        explanation: 'Drum is percussion while others can play melody.',
      ),
      Question(
        id: 'crit_35',
        categoryId: 'critical_thinking',
        text: 'Complete analogy: Author is to Book as Chef is to ?',
        options: ['Restaurant', 'Food', 'Recipe', 'Kitchen'],
        correctAnswerIndex: 2,
        explanation: 'Author creates book, chef creates recipe.',
      ),
      Question(
        id: 'crit_36',
        categoryId: 'critical_thinking',
        text: 'What comes next: A, Z, B, Y, C, ?',
        options: ['D', 'W', 'X', 'V'],
        correctAnswerIndex: 2,
        explanation: 'Alternating from beginning and end: A (1st), Z (26th), B (2nd), Y (25th), C (3rd), X (24th)',
      ),
      Question(
        id: 'crit_37',
        categoryId: 'critical_thinking',
        text: 'If some doctors are researchers and all researchers are educated, then:',
        options: [
          'All doctors are educated',
          'Some doctors are educated',
          'No doctors are educated',
          'All educated people are doctors'
        ],
        correctAnswerIndex: 1,
        explanation: 'Some doctors are researchers and all researchers are educated, so some doctors are educated.',
      ),
      Question(
        id: 'crit_38',
        categoryId: 'critical_thinking',
        text: 'Find odd one: Oxygen, Hydrogen, Water, Nitrogen, Carbon',
        options: ['Oxygen', 'Hydrogen', 'Water', 'Nitrogen'],
        correctAnswerIndex: 2,
        explanation: 'Water is a compound while others are elements.',
      ),
      Question(
        id: 'crit_39',
        categoryId: 'critical_thinking',
        text: 'Complete: 2, 6, 18, 54, ?',
        options: ['108', '162', '216', '270'],
        correctAnswerIndex: 1,
        explanation: 'Multiply by 3: 2×3=6, 6×3=18, 18×3=54, 54×3=162',
      ),
      Question(
        id: 'crit_40',
        categoryId: 'critical_thinking',
        text: 'Complete analogy: Brush is to Paint as Pen is to ?',
        options: ['Write', 'Ink', 'Paper', 'Draw'],
        correctAnswerIndex: 1,
        explanation: 'Brush uses paint, pen uses ink.',
      ),
      Question(
        id: 'crit_41',
        categoryId: 'critical_thinking',
        text: 'What comes next: 5, 10, 20, 40, ?',
        options: ['60', '70', '80', '90'],
        correctAnswerIndex: 2,
        explanation: 'Multiply by 2: 5×2=10, 10×2=20, 20×2=40, 40×2=80',
      ),
      Question(
        id: 'crit_42',
        categoryId: 'critical_thinking',
        text: 'If all roses are plants and some plants are medicinal, then:',
        options: [
          'All roses are medicinal',
          'Some roses are medicinal',
          'No roses are medicinal',
          'All medicinal things are plants'
        ],
        correctAnswerIndex: 1,
        explanation: 'All roses are plants and some plants are medicinal, so some roses could be medicinal.',
      ),
      Question(
        id: 'crit_43',
        categoryId: 'critical_thinking',
        text: 'Find odd one: Apple, Microsoft, Google, Facebook, Amazon',
        options: ['Apple', 'Microsoft', 'Google', 'Amazon'],
        correctAnswerIndex: 0,
        explanation: 'Apple was originally a hardware company while others were primarily software/internet.',
      ),
      Question(
        id: 'crit_44',
        categoryId: 'critical_thinking',
        text: 'Complete analogy: Hour is to Minute as Minute is to ?',
        options: ['Day', 'Second', 'Time', 'Clock'],
        correctAnswerIndex: 1,
        explanation: 'Hour contains minutes, minute contains seconds.',
      ),
      Question(
        id: 'crit_45',
        categoryId: 'critical_thinking',
        text: 'What comes next: 1, 8, 27, 64, ?',
        options: ['100', '121', '125', '144'],
        correctAnswerIndex: 2,
        explanation: 'Cube numbers: 1³=1, 2³=8, 3³=27, 4³=64, 5³=125',
      ),
      Question(
        id: 'crit_46',
        categoryId: 'critical_thinking',
        text: 'If no fish are mammals and all dolphins are mammals, then:',
        options: [
          'Some dolphins are fish',
          'No dolphins are fish',
          'All fish are dolphins',
          'Some mammals are not dolphins'
        ],
        correctAnswerIndex: 1,
        explanation: 'All dolphins are mammals and no fish are mammals, so no dolphins are fish.',
      ),
      Question(
        id: 'crit_47',
        categoryId: 'critical_thinking',
        text: 'Find odd one: Shakespeare, Dickens, Austen, Picasso, Hemingway',
        options: ['Shakespeare', 'Dickens', 'Picasso', 'Hemingway'],
        correctAnswerIndex: 2,
        explanation: 'Picasso was a painter while others were writers.',
      ),
      Question(
        id: 'crit_48',
        categoryId: 'critical_thinking',
        text: 'Complete: 100, 90, 81, 73, 66, ?',
        options: ['60', '61', '62', '63'],
        correctAnswerIndex: 0,
        explanation: 'Subtract decreasing amounts: -10, -9, -8, -7, -6 → 66 - 6 = 60',
      ),
      Question(
        id: 'crit_49',
        categoryId: 'critical_thinking',
        text: 'Complete analogy: Teacher is to Student as Doctor is to ?',
        options: ['Patient', 'Hospital', 'Medicine', 'Nurse'],
        correctAnswerIndex: 0,
        explanation: 'Teacher teaches student, doctor treats patient.',
      ),
      Question(
        id: 'crit_50',
        categoryId: 'critical_thinking',
        text: 'What comes next: 1, 3, 6, 10, 15, ?',
        options: ['20', '21', '22', '23'],
        correctAnswerIndex: 1,
        explanation: 'Triangular numbers: +2, +3, +4, +5, +6 → 15 + 6 = 21',
      ),
    ];
  }
}