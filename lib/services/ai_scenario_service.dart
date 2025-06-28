import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class AIScenarioService {
  // Multiple AI providers support
  static const String _openAIUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';
  static const String _claudeUrl = 'https://api.anthropic.com/v1/messages';
  
  // API Keys - Set these via environment variables or app settings
  static const String _openAIKey = 'YOUR_OPENAI_API_KEY_HERE';
  static const String _geminiKey = 'YOUR_GEMINI_API_KEY_HERE'; 
  static const String _claudeKey = 'YOUR_CLAUDE_API_KEY_HERE';
  
  // Current provider (can be changed based on availability)
  static const String _currentProvider = 'openai'; // 'openai', 'gemini', 'claude'
  
  // Enhanced fallback scenarios based on real 2024-25 financial trends
  static final List<Map<String, dynamic>> _fallbackScenarios = [
    {
      'title': 'Crypto vs Traditional Investment Dilemma',
      'description': 'Bitcoin hits ₹35 lakh while your SIP portfolio struggles. Your tech-savvy cousin made ₹50 lakhs in crypto in 2 years. You have ₹8 lakhs in an ELSS fund showing 12% returns. Friends are going crazy over a new altcoin that doubled in 3 months. Your father warns about "digital gambling" while WhatsApp groups share success stories.',
      'choices': [
        {
          'text': 'Partially move to crypto (₹2L)',
          'description': 'Diversify with limited crypto',
          'moneyImpact': 400000.0,
          'happinessImpact': 20,
          'stressImpact': 35,
          'knowledgeImpact': 25,
          'creditScoreImpact': 0,
          'outcomeText': 'Smart timing! Your ₹2L became ₹6L as crypto surged. But you faced sleepless nights watching daily volatility. Family tensions arose over your "risky" choices.',
        },
        {
          'text': 'Stay with traditional SIPs',
          'description': 'Stick to proven methods',
          'moneyImpact': 150000.0,
          'happinessImpact': 15,
          'stressImpact': 10,
          'knowledgeImpact': 15,
          'creditScoreImpact': 5,
          'outcomeText': 'Disciplined approach paid off. While friends faced crypto crashes, your systematic SIPs grew steadily to ₹12 lakhs over 3 years. Peace of mind was priceless.',
        },
        {
          'text': 'Research and wait for better entry',
          'description': 'Study before investing',
          'moneyImpact': -50000.0,
          'happinessImpact': 5,
          'stressImpact': 20,
          'knowledgeImpact': 30,
          'outcomeText': 'Analysis paralysis cost you. By the time you "understood" crypto, prices had doubled. However, your research skills improved dramatically for future decisions.',
        },
      ]
    },
    {
      'title': 'Real Estate vs REITs: The New Age Property Dilemma',
      'description': 'Gurgaon property prices jumped 40% in 2 years. A 2BHK costs ₹1.2 crores with 20% down payment needed. Your savings: ₹30 lakhs. Alternative: Invest in Embassy REIT giving 7% dividend yield and potential capital appreciation. Your spouse dreams of owning a house, but EMI would be ₹85,000/month vs your ₹1.2L salary.',
      'choices': [
        {
          'text': 'Buy the house with home loan',
          'description': 'Fulfill the dream',
          'moneyImpact': 1200000.0,
          'happinessImpact': 30,
          'stressImpact': 45,
          'knowledgeImpact': 20,
          'creditScoreImpact': 20,
          'outcomeText': 'Property appreciation made you wealthy! House worth ₹1.8 crores after 4 years. However, high EMIs limited lifestyle choices and investment opportunities.',
        },
        {
          'text': 'Invest in REITs and rent a house',
          'description': 'Liquid real estate exposure',
          'moneyImpact': 800000.0,
          'happinessImpact': 15,
          'stressImpact': 25,
          'knowledgeImpact': 30,
          'creditScoreImpact': 10,
          'outcomeText': 'REITs generated steady 8.5% annual returns. Rental flexibility allowed job changes. But missed the property boom and faced family pressure about "not owning".',
        },
        {
          'text': 'Wait for property prices to cool',
          'description': 'Time the market',
          'moneyImpact': 200000.0,
          'happinessImpact': 10,
          'stressImpact': 30,
          'knowledgeImpact': 25,
          'creditScoreImpact': 0,
          'outcomeText': 'Prices never came down. You invested savings in FDs earning 6.5%. Safe but inflation eroded real returns. Still searching for that perfect entry point.',
        },
      ]
    },
    {
      'title': 'IPO FOMO: Paytm to Zomato Rollercoaster',
      'description': 'Your broker calls about Zomato IPO at ₹76. Friends are applying for ₹2 lakh each, expecting Paytm-like listing gains. You have ₹5 lakhs in savings. Memories of Paytm\'s 27% listing loss haunt investors, but Zomato\'s food delivery monopoly looks promising. Social media influencers predict 50% listing gains.',
      'choices': [
        {
          'text': 'Apply for maximum IPO amount',
          'description': 'Big bet on listing gains',
          'moneyImpact': 600000.0,
          'happinessImpact': 25,
          'stressImpact': 40,
          'knowledgeImpact': 25,
          'creditScoreImpact': 0,
          'outcomeText': 'Lucky break! Got full allotment and sold at ₹130 on listing day. Made ₹1.4 lakhs profit in one day. But developed gambling mindset for future IPOs.',
        },
        {
          'text': 'Apply for minimum amount (₹15K)',
          'description': 'Conservative participation',
          'moneyImpact': 100000.0,
          'happinessImpact': 15,
          'stressImpact': 15,
          'knowledgeImpact': 20,
          'creditScoreImpact': 0,
          'outcomeText': 'Balanced approach worked. Small profit without major risk. Used learnings to build a systematic IPO investment strategy for quality companies only.',
        },
        {
          'text': 'Skip IPO, invest in index funds',
          'description': 'Avoid speculation',
          'moneyImpact': 250000.0,
          'happinessImpact': 18,
          'stressImpact': 10,
          'knowledgeImpact': 15,
          'creditScoreImpact': 5,
          'outcomeText': 'Boring but profitable. Index funds delivered steady 14% returns while friends lost money in subsequent IPO failures. Consistency beats speculation.',
        },
      ]
    },
  ];

  static Future<Map<String, dynamic>> generateScenario({
    required String playerName,
    required String lifeStage,
    required double currentSavings,
    required int creditScore,
    required String previousChoices,
  }) async {
    try {
      return await _generateAIScenario(
        playerName: playerName,
        lifeStage: lifeStage,
        currentSavings: currentSavings,
        creditScore: creditScore,
        previousChoices: previousChoices,
      );
    } catch (e) {
      print('AI generation failed, using fallback: $e');
      return _getFallbackScenario();
    }
  }

  static Future<Map<String, dynamic>> _generateAIScenario({
    required String playerName,
    required String lifeStage,
    required double currentSavings,
    required int creditScore,
    required String previousChoices,
  }) async {
    switch (_currentProvider) {
      case 'openai':
        return await _generateOpenAIScenario(
          playerName: playerName,
          lifeStage: lifeStage,
          currentSavings: currentSavings,
          creditScore: creditScore,
          previousChoices: previousChoices,
        );
      case 'gemini':
        return await _generateGeminiScenario(
          playerName: playerName,
          lifeStage: lifeStage,
          currentSavings: currentSavings,
          creditScore: creditScore,
          previousChoices: previousChoices,
        );
      case 'claude':
        return await _generateClaudeScenario(
          playerName: playerName,
          lifeStage: lifeStage,
          currentSavings: currentSavings,
          creditScore: creditScore,
          previousChoices: previousChoices,
        );
      default:
        throw Exception('Unsupported AI provider: $_currentProvider');
    }
  }

  static Future<Map<String, dynamic>> _generateOpenAIScenario({
    required String playerName,
    required String lifeStage,
    required double currentSavings,
    required int creditScore,
    required String previousChoices,
  }) async {
    final prompt = _buildEnhancedPrompt(
      playerName: playerName,
      lifeStage: lifeStage,
      currentSavings: currentSavings,
      creditScore: creditScore,
      previousChoices: previousChoices,
    );

    final response = await http.post(
      Uri.parse(_openAIUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openAIKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini', // More cost-effective than GPT-4
        'messages': [
          {
            'role': 'system',
            'content': _getSystemPrompt(),
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ],
        'max_tokens': 1500,
        'temperature': 0.8,
        'response_format': {'type': 'json_object'},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return _parseAIResponse(content);
    } else {
      throw Exception('OpenAI API request failed: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> _generateGeminiScenario({
    required String playerName,
    required String lifeStage,
    required double currentSavings,
    required int creditScore,
    required String previousChoices,
  }) async {
    final prompt = _buildEnhancedPrompt(
      playerName: playerName,
      lifeStage: lifeStage,
      currentSavings: currentSavings,
      creditScore: creditScore,
      previousChoices: previousChoices,
    );

    final response = await http.post(
      Uri.parse('$_geminiUrl?key=$_geminiKey'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': '${_getSystemPrompt()}\n\n$prompt'
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.8,
          'maxOutputTokens': 1500,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['candidates'][0]['content']['parts'][0]['text'];
      return _parseAIResponse(content);
    } else {
      throw Exception('Gemini API request failed: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> _generateClaudeScenario({
    required String playerName,
    required String lifeStage,
    required double currentSavings,
    required int creditScore,
    required String previousChoices,
  }) async {
    final prompt = _buildEnhancedPrompt(
      playerName: playerName,
      lifeStage: lifeStage,
      currentSavings: currentSavings,
      creditScore: creditScore,
      previousChoices: previousChoices,
    );

    final response = await http.post(
      Uri.parse(_claudeUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _claudeKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-3-haiku-20240307',
        'max_tokens': 1500,
        'temperature': 0.8,
        'system': _getSystemPrompt(),
        'messages': [
          {
            'role': 'user',
            'content': prompt,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['content'][0]['text'];
      return _parseAIResponse(content);
    } else {
      throw Exception('Claude API request failed: ${response.statusCode} - ${response.body}');
    }
  }

  static String _getSystemPrompt() {
    return '''You are an expert Indian financial advisor and life simulation game designer. Your expertise includes:

- Current Indian financial market conditions (2024-25)
- Investment options: Mutual funds, stocks, real estate, gold, crypto, FDs, bonds
- Government schemes: PPF, EPF, ELSS, NPS, PMVVY, etc.
- Banking: Credit cards, loans, EMIs, credit scores
- Insurance: Term, health, vehicle, property
- Tax planning: Income tax, capital gains, Section 80C, etc.
- Cultural context: Joint families, festivals, marriages, education costs

Create ultra-realistic financial scenarios that an Indian person would actually face. Include:
- Specific brand names (SBI, HDFC, ICICI, Reliance, Tata, etc.)
- Real city names and property prices
- Current market conditions and rates
- Family dynamics and cultural obligations
- Emotional and psychological factors

Make each scenario challenging with no obvious "correct" answer. Each choice should have realistic trade-offs and long-term consequences.

Respond ONLY with valid JSON in the exact format specified.''';
  }

  static String _buildEnhancedPrompt({
    required String playerName,
    required String lifeStage,
    required double currentSavings,
    required int creditScore,
    required String previousChoices,
  }) {
    // Get current date context
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    
    // Determine financial season context
    String seasonContext = '';
    if (currentMonth >= 1 && currentMonth <= 3) {
      seasonContext = 'Tax saving season (Jan-Mar), budget announcement period';
    } else if (currentMonth >= 4 && currentMonth <= 6) {
      seasonContext = 'New financial year start, bonus season in many companies';
    } else if (currentMonth >= 7 && currentMonth <= 9) {
      seasonContext = 'Monsoon season, festival season approaching';
    } else {
      seasonContext = 'Festival season (Diwali, Dussehra), wedding season, year-end planning';
    }

    return '''
PLAYER PROFILE:
- Name: $playerName
- Life Stage: $lifeStage
- Current Savings: ₹${_formatIndianCurrency(currentSavings)}
- Credit Score: $creditScore
- Previous Financial Decisions: $previousChoices

CURRENT CONTEXT ($currentYear):
- Season: $seasonContext
- Economic Environment: Post-pandemic recovery, inflation concerns, tech growth
- Market Conditions: Volatile equity markets, rising interest rates, real estate boom
- Government Focus: Digital payments, startup ecosystem, green energy

SCENARIO REQUIREMENTS:
Create a complex financial dilemma based on REAL current events and market conditions. Include:

1. SPECIFIC DETAILS:
   - Exact amounts in ₹ (use lakhs/crores appropriately)
   - Real brand names (HDFC Bank, SBI, Zerodha, Groww, etc.)
   - Actual city names with realistic property prices
   - Current interest rates and market returns

2. CULTURAL CONTEXT:
   - Family obligations and expectations
   - Social pressures and peer comparisons
   - Festival/wedding expenses
   - Career vs. family balance

3. EMOTIONAL FACTORS:
   - Risk tolerance based on life stage
   - Fear of missing out (FOMO)
   - Security vs. growth desires
   - Social status considerations

4. REALISTIC OUTCOMES:
   - Market-based returns (8-15% for equity, 6-8% for debt)
   - Inflation impact (5-7% annually)
   - Tax implications
   - Time value of money

Generate JSON in this EXACT format:
{
  "title": "Compelling scenario title (under 60 characters)",
  "description": "Detailed 200-250 word scenario with specific numbers, brands, and emotional context. Make it feel like a real newspaper headline or personal finance blog post.",
  "choices": [
    {
      "text": "Choice 1 (under 50 characters)",
      "description": "Brief explanation (under 30 characters)",
      "moneyImpact": 150000.0,
      "happinessImpact": 15,
      "stressImpact": 25,
      "knowledgeImpact": 20,
      "creditScoreImpact": 10,
      "outcomeText": "Detailed 100-150 word outcome with specific numbers, timeframes, and consequences. Include both immediate and long-term effects."
    },
    {
      "text": "Choice 2",
      "description": "Brief explanation",
      "moneyImpact": -50000.0,
      "happinessImpact": 10,
      "stressImpact": 40,
      "knowledgeImpact": 30,
      "creditScoreImpact": -5,
      "outcomeText": "Realistic outcome with market data and personal consequences"
    },
    {
      "text": "Choice 3",
      "description": "Brief explanation",
      "moneyImpact": 300000.0,
      "happinessImpact": 25,
      "stressImpact": 50,
      "knowledgeImpact": 35,
      "creditScoreImpact": 20,
      "outcomeText": "High-risk, high-reward outcome with detailed explanation"
    }
  ]
}

IMPORTANT: 
- Make it feel like a real financial decision someone would face TODAY
- Include current market rates, brand names, and regulatory changes
- Show realistic trade-offs - no perfect choices
- Base impacts on the player's current financial situation
- Use psychological triggers relevant to the life stage
''';
  }

  static String _formatIndianCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  static Map<String, dynamic> _parseAIResponse(String content) {
    try {
      // Extract JSON from the response (sometimes AI adds extra text)
      final startIndex = content.indexOf('{');
      final endIndex = content.lastIndexOf('}') + 1;
      
      if (startIndex != -1 && endIndex > startIndex) {
        final jsonString = content.substring(startIndex, endIndex);
        return jsonDecode(jsonString);
      } else {
        throw Exception('No valid JSON found in response');
      }
    } catch (e) {
      print('Failed to parse AI response: $e');
      throw Exception('Failed to parse AI response');
    }
  }

  static Map<String, dynamic> _getFallbackScenario() {
    final random = Random();
    return _fallbackScenarios[random.nextInt(_fallbackScenarios.length)];
  }

  // Enhanced fallback with more variety
  static Map<String, dynamic> generateContextualFallback({
    required String lifeStage,
    required double currentSavings,
    required int creditScore,
  }) {
    final random = Random();
    
    // Generate scenario based on life stage and savings
    if (lifeStage.contains('College') && currentSavings < 100000) {
      return _generateStudentScenario();
    } else if (lifeStage.contains('First Job') && currentSavings < 500000) {
      return _generateFirstJobScenario();
    } else if (currentSavings > 2000000) {
      return _generateWealthyScenario();
    } else {
      return _fallbackScenarios[random.nextInt(_fallbackScenarios.length)];
    }
  }

  static Map<String, dynamic> _generateStudentScenario() {
    final scenarios = [
      {
        'title': 'Education Loan vs Coding Bootcamp Dilemma',
        'description': 'IIT fee is ₹15 lakhs for 4 years. Alternative: 6-month coding bootcamp costs ₹3 lakhs with 90% placement guarantee at ₹8-12 LPA. Your family can arrange ₹8 lakhs by mortgaging house. Tech recruiters prefer skills over degrees now.',
        'choices': [
          {
            'text': 'Take education loan for IIT',
            'description': 'Traditional prestigious path',
            'moneyImpact': -200000.0,
            'happinessImpact': 15,
            'stressImpact': 30,
            'knowledgeImpact': 35,
            'creditScoreImpact': 25,
            'outcomeText': 'IIT brand opened global opportunities. Got placed at ₹45 LPA in Google after graduation. Loan repaid in 2 years with exponential career growth.',
          },
          {
            'text': 'Choose coding bootcamp',
            'description': 'Quick skill-based entry',
            'moneyImpact': 400000.0,
            'happinessImpact': 20,
            'stressImpact': 20,
            'knowledgeImpact': 25,
            'creditScoreImpact': 10,
            'outcomeText': 'Landed job at ₹10 LPA within 8 months. Started earning early but hit career ceiling without degree. Pursued part-time engineering later.',
          },
          {
            'text': 'Self-learn and freelance',
            'description': 'Bootstrap approach',
            'moneyImpact': 600000.0,
            'happinessImpact': 25,
            'stressImpact': 40,
            'knowledgeImpact': 30,
            'creditScoreImpact': -5,
            'outcomeText': 'Built successful freelance business earning ₹15+ LPA. Complete freedom but irregular income created stress. No corporate benefits or security.',
          },
        ]
      },
      {
        'title': 'Internship Stipend Investment Challenge',
        'description': 'Your tech internship pays ₹50,000/month for 6 months. Living expenses: ₹25,000. Friends spend remainder on gadgets and trips. You\'re considering investing ₹25,000 monthly in equity mutual funds vs keeping as emergency fund.',
        'choices': [
          {
            'text': 'Start SIP immediately',
            'description': 'Begin wealth creation early',
            'moneyImpact': 250000.0,
            'happinessImpact': 20,
            'stressImpact': 15,
            'knowledgeImpact': 30,
            'creditScoreImpact': 15,
            'outcomeText': 'Compound interest magic! Your ₹1.5L investment became ₹12L over 8 years through consistent SIPs. Started retirement planning at 22.',
          },
          {
            'text': 'Keep as emergency fund',
            'description': 'Build financial safety net',
            'moneyImpact': 50000.0,
            'happinessImpact': 15,
            'stressImpact': 5,
            'knowledgeImpact': 20,
            'creditScoreImpact': 10,
            'outcomeText': 'Emergency fund saved you during job transition. Avoided credit card debt when laptop broke. Provided confidence to take career risks later.',
          },
        ]
      }
    ];
    
    final random = Random();
    return scenarios[random.nextInt(scenarios.length)];
  }

  static Map<String, dynamic> _generateFirstJobScenario() {
    final scenarios = [
      {
        'title': 'First Job Financial Independence Strategy',
        'description': 'Salary: ₹8 LPA in Bangalore. Room rent: ₹15K. Parents expect ₹10K monthly support. You want to save ₹30K but also build credit history. Friends suggest taking personal loan to buy bike for convenience vs using public transport.',
        'choices': [
          {
            'text': 'Take bike loan, build credit',
            'description': 'Convenience + credit building',
            'moneyImpact': 150000.0,
            'happinessImpact': 25,
            'stressImpact': 20,
            'knowledgeImpact': 20,
            'creditScoreImpact': 30,
            'outcomeText': 'Bike improved productivity and comfort. Good EMI history built excellent credit score. Got pre-approved home loan at best rates 3 years later.',
          },
          {
            'text': 'Use public transport, max savings',
            'description': 'Frugal wealth building',
            'moneyImpact': 300000.0,
            'happinessImpact': 15,
            'stressImpact': 25,
            'knowledgeImpact': 25,
            'creditScoreImpact': 5,
            'outcomeText': 'Saved ₹40K monthly for 2 years. Built ₹10L corpus for house down payment. But limited credit history affected loan negotiations.',
          },
          {
            'text': 'Credit card for expenses',
            'description': 'Cashback and credit building',
            'moneyImpact': 200000.0,
            'happinessImpact': 20,
            'stressImpact': 30,
            'knowledgeImpact': 30,
            'creditScoreImpact': 20,
            'outcomeText': 'Managed credit responsibly. Earned ₹15K annual cashbacks and built strong credit. However, one month\'s overspending created stress.',
          },
        ]
      },
      {
        'title': 'Salary Increment Allocation Dilemma',
        'description': 'Got promoted! Salary increased from ₹8L to ₹12L. Lifestyle inflation beckons - friends suggest upgrading to 1BHK (₹25K vs current ₹15K), eating out more. Parents want you to start looking for marriage. Financial advisor suggests increasing investments.',
        'choices': [
          {
            'text': 'Upgrade lifestyle moderately',
            'description': 'Balance comfort and savings',
            'moneyImpact': 180000.0,
            'happinessImpact': 22,
            'stressImpact': 15,
            'knowledgeImpact': 15,
            'creditScoreImpact': 10,
            'outcomeText': 'Found perfect balance. Better accommodation improved work-life quality. Still saved ₹35K monthly, building wealth while enjoying success.',
          },
          {
            'text': 'Maintain current lifestyle',
            'description': 'Maximize investment increase',
            'moneyImpact': 400000.0,
            'happinessImpact': 18,
            'stressImpact': 20,
            'knowledgeImpact': 25,
            'creditScoreImpact': 15,
            'outcomeText': 'Impressive discipline! Increased SIP to ₹50K monthly. Built ₹20L corpus in 3 years. But social life suffered due to extreme frugality.',
          },
        ]
      }
    ];
    
    final random = Random();
    return scenarios[random.nextInt(scenarios.length)];
  }

  static Map<String, dynamic> _generateWealthyScenario() {
    final scenarios = [
      {
        'title': 'Angel Investment vs Traditional Diversification',
        'description': 'Portfolio worth ₹2 crores. Your ex-colleague\'s AI startup seeks ₹50L angel funding, offering 5% equity. They have Sequoia interest for Series A. Alternative: diversify across international funds, REITs, and gold. Startup could be next unicorn or total loss.',
        'choices': [
          {
            'text': 'Angel invest ₹50L in startup',
            'description': 'High-risk venture capital',
            'moneyImpact': 5000000.0,
            'happinessImpact': 30,
            'stressImpact': 50,
            'knowledgeImpact': 35,
            'creditScoreImpact': 0,
            'outcomeText': 'Startup became unicorn in 3 years! Your ₹50L became ₹15 crores. However, 80% of your angel investments failed. Net result: massive win.',
          },
          {
            'text': 'Diversified portfolio approach',
            'description': 'Risk-managed growth',
            'moneyImpact': 1200000.0,
            'happinessImpact': 20,
            'stressImpact': 20,
            'knowledgeImpact': 25,
            'creditScoreImpact': 5,
            'outcomeText': 'Achieved 12% annual returns through balanced allocation. Portfolio grew to ₹3.2 crores over 4 years. Missed unicorn gains but slept peacefully.',
          },
          {
            'text': 'Real estate + startup combo',
            'description': 'Balanced approach',
            'moneyImpact': 2500000.0,
            'happinessImpact': 25,
            'stressImpact': 35,
            'knowledgeImpact': 30,
            'creditScoreImpact': 10,
            'outcomeText': 'Best of both worlds. Real estate provided stability (₹1.5Cr), startup partial exit gave ₹2Cr. Total portfolio: ₹5.5 crores in 4 years.',
          },
        ]
      },
      {
        'title': 'Tax Optimization vs Philanthropy Decision',
        'description': 'Annual income: ₹75L. Tax liability: ₹18L. Options: Aggressive tax planning through real estate investments could save ₹8L annually. Alternative: Start a foundation, claim 50% deduction while creating social impact. Third option: Pay full tax, invest the savings amount.',
        'choices': [
          {
            'text': 'Aggressive tax optimization',
            'description': 'Maximize wealth retention',
            'moneyImpact': 800000.0,
            'happinessImpact': 15,
            'stressImpact': 25,
            'knowledgeImpact': 30,
            'creditScoreImpact': 0,
            'outcomeText': 'Saved ₹32L over 4 years through legal structures. However, complex compliance and audit scrutiny created ongoing stress. Wealth preserved.',
          },
          {
            'text': 'Start philanthropic foundation',
            'description': 'Impact + tax benefits',
            'moneyImpact': 400000.0,
            'happinessImpact': 35,
            'stressImpact': 30,
            'knowledgeImpact': 25,
            'creditScoreImpact': 5,
            'outcomeText': 'Foundation funded 500 scholarships. Tax benefits + social recognition enhanced business opportunities. Indirect ROI through network effects.',
          },
          {
            'text': 'Pay tax, invest the difference',
            'description': 'Simple and compliant',
            'moneyImpact': 600000.0,
            'happinessImpact': 20,
            'stressImpact': 10,
            'knowledgeImpact': 20,
            'creditScoreImpact': 10,
            'outcomeText': 'Clean tax record and peace of mind. Invested tax savings in equity markets. Generated ₹15% returns, offsetting tax optimization benefits.',
          },
        ]
      }
    ];
    
    final random = Random();
    return scenarios[random.nextInt(scenarios.length)];
  }

  /// Validates if an API key is configured for the current provider
  static bool isAPIKeyConfigured() {
    switch (_currentProvider) {
      case 'openai':
        return _openAIKey != 'YOUR_OPENAI_API_KEY_HERE' && _openAIKey.isNotEmpty;
      case 'gemini':
        return _geminiKey != 'YOUR_GEMINI_API_KEY_HERE' && _geminiKey.isNotEmpty;
      case 'claude':
        return _claudeKey != 'YOUR_CLAUDE_API_KEY_HERE' && _claudeKey.isNotEmpty;
      default:
        return false;
    }
  }
  
  /// Gets the current provider status for debugging
  static Map<String, dynamic> getProviderStatus() {
    return {
      'currentProvider': _currentProvider,
      'isAPIKeyConfigured': isAPIKeyConfigured(),
      'availableProviders': ['openai', 'gemini', 'claude'],
      'fallbackScenariosCount': _fallbackScenarios.length,
    };
  }
  
  /// Generates scenario with automatic fallback handling
  static Future<Map<String, dynamic>> generateScenarioWithFallback({
    required String playerName,
    required String lifeStage,
    required double currentSavings,
    required int creditScore,
    required String previousChoices,
  }) async {
    // Try AI generation if API is configured
    if (isAPIKeyConfigured()) {
      try {
        return await _generateAIScenario(
          playerName: playerName,
          lifeStage: lifeStage,
          currentSavings: currentSavings,
          creditScore: creditScore,
          previousChoices: previousChoices,
        );
      } catch (e) {
        print('AI generation failed, using contextual fallback: $e');
      }
    }
    
    // Use contextual fallback
    return generateContextualFallback(
      lifeStage: lifeStage,
      currentSavings: currentSavings,
      creditScore: creditScore,
    );
  }
  
  /// Generates trending financial scenarios based on current market conditions
  static Map<String, dynamic> generateTrendingScenario() {
    final trendingScenarios = [
      {
        'title': 'EV Stocks vs Traditional Auto: Future Mobility Bet',
        'description': 'Tesla India launch imminent. Tata Motors stock hit ₹900 while Ola Electric IPO creates buzz. Your portfolio has ₹3L in Maruti Suzuki showing modest gains. Friends made 300% in EV stocks last year. Government pushes electric mobility with subsidies.',
        'choices': [
          {
            'text': 'Shift to EV stocks portfolio',
            'description': 'Bet on electric future',
            'moneyImpact': 800000.0,
            'happinessImpact': 25,
            'stressImpact': 40,
            'knowledgeImpact': 30,
            'creditScoreImpact': 0,
            'outcomeText': 'EV revolution paid off! Your portfolio doubled as government announced aggressive electrification targets. However, high volatility tested your nerves daily.',
          },
          {
            'text': 'Diversify across mobility themes',
            'description': 'Balanced transport exposure',
            'moneyImpact': 400000.0,
            'happinessImpact': 20,
            'stressImpact': 25,
            'knowledgeImpact': 25,
            'creditScoreImpact': 5,
            'outcomeText': 'Smart diversification cushioned EV stock corrections. Traditional auto stocks provided stability while EV exposure gave growth. Optimal risk-return balance.',
          },
          {
            'text': 'Wait for EV sector correction',
            'description': 'Time the entry better',
            'moneyImpact': 100000.0,
            'happinessImpact': 15,
            'stressImpact': 30,
            'knowledgeImpact': 20,
            'creditScoreImpact': 0,
            'outcomeText': 'Missed the momentum. EV stocks continued rallying without major correction. Your patience was rewarded with smaller gains from traditional picks.',
          },
        ]
      },
      {
        'title': 'Mutual Fund vs Direct Stock Investment Revolution',
        'description': 'Zerodha, Groww made stock investing accessible. Your ₹50K monthly SIP in diversified funds gives steady 12% returns. Friends earn 25%+ picking individual stocks. Apps offer stock tips, smallcase themes, and momentum strategies.',
        'choices': [
          {
            'text': 'Switch to direct stock picking',
            'description': 'Higher returns potential',
            'moneyImpact': 600000.0,
            'happinessImpact': 20,
            'stressImpact': 45,
            'knowledgeImpact': 35,
            'creditScoreImpact': 0,
            'outcomeText': 'Hit jackpot with few multibagger picks! Made ₹8L profit in 2 years. But time spent researching stocks affected work productivity and relationships.',
          },
          {
            'text': 'Hybrid approach: 70% MF, 30% stocks',
            'description': 'Best of both worlds',
            'moneyImpact': 350000.0,
            'happinessImpact': 22,
            'stressImpact': 30,
            'knowledgeImpact': 30,
            'creditScoreImpact': 5,
            'outcomeText': 'Perfect balance! MF SIPs provided stability while stock picks added excitement. Learned investing skills without sacrificing peace of mind.',
          },
          {
            'text': 'Continue with systematic SIPs',
            'description': 'Avoid speculation',
            'moneyImpact': 200000.0,
            'happinessImpact': 18,
            'stressImpact': 15,
            'knowledgeImpact': 20,
            'creditScoreImpact': 10,
            'outcomeText': 'Disciplined approach won in long run. While friends faced losses in stock crashes, your SIPs continued generating consistent 14% annual returns.',
          },
        ]
      }
    ];
    
    final random = Random();
    return trendingScenarios[random.nextInt(trendingScenarios.length)];
  }
}
