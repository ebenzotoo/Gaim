import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../components/Constants/colors.dart';

class DailyScriptureScreen extends StatefulWidget {
  const DailyScriptureScreen({super.key});

  @override
  _DailyScriptureScreenState createState() => _DailyScriptureScreenState(); // ignore: library_private_types_in_public_api
}

class _DailyScriptureScreenState extends State<DailyScriptureScreen> {
  String _currentScripture = '';

  final List<String> _scriptures = [
    'For I know the plans I have for you, declares the Lord, plans for welfare and not for evil, to give you a future and a hope. - Jeremiah 29:11',
    'The Lord is my shepherd; I shall not want. - Psalm 23:1',
    'I can do all things through him who strengthens me. - Philippians 4:13',
    'But seek first the kingdom of God and his righteousness, and all these things will be added to you. - Matthew 6:33',
    'Be strong and courageous. Do not be frightened, and do not be dismayed, for the Lord your God is with you wherever you go. - Joshua 1:9',
    'For I know the plans I have for you, declares the Lord, plans for welfare and not for evil, to give you a future and a hope. - Jeremiah 29:11',
    'The Lord is my shepherd; I shall not want. - Psalm 23:1',
    'I can do all things through him who strengthens me. - Philippians 4:13',
    'But seek first the kingdom of God and his righteousness, and all these things will be added to you. - Matthew 6:33',
    'Be strong and courageous. Do not be frightened, and do not be dismayed, for the Lord your God is with you wherever you go. - Joshua 1:9',
    'Trust in the Lord with all your heart, and do not lean on your own understanding. - Proverbs 3:5',
    'The Lord is my light and my salvation; whom shall I fear? The Lord is the stronghold of my life; of whom shall I be afraid? - Psalm 27:1',
    'Jesus said to him, "I am the way, and the truth, and the life. No one comes to the Father except through me." - John 14:6',
    'In the beginning, God created the heavens and the earth. - Genesis 1:1',
    'And we know that in all things God works for the good of those who love him, who have been called according to his purpose. - Romans 8:28',
    'Cast all your anxiety on him because he cares for you. - 1 Peter 5:7',
    'Do not be conformed to this world, but be transformed by the renewal of your mind. - Romans 12:2',
    'Let all that you do be done in love. - 1 Corinthians 16:14',
    'The fruit of the Spirit is love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, and self-control. - Galatians 5:22-23',
    'The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning. - Lamentations 3:22-23',
    'For God gave us a spirit not of fear but of power and love and self-control. - 2 Timothy 1:7',
    'I have told you these things, so that in me you may have peace. In this world you will have trouble. But take heart! I have overcome the world. - John 16:33',
    'Therefore, if anyone is in Christ, he is a new creation. The old has passed away; behold, the new has come. - 2 Corinthians 5:17',
    'So now faith, hope, and love abide, these three; but the greatest of these is love. - 1 Corinthians 13:13',
    'You keep him in perfect peace whose mind is stayed on you, because he trusts in you. - Isaiah 26:3',
    'But those who hope in the Lord will renew their strength; they will soar on wings like eagles. - Isaiah 40:31',
    'And my God will supply every need of yours according to his riches in glory in Christ Jesus. - Philippians 4:19',
    'The name of the Lord is a strong tower; the righteous run to it and are safe. - Proverbs 18:10',
    'Rejoice in hope, be patient in tribulation, be constant in prayer. - Romans 12:12',
    'For where two or three are gathered in my name, there am I among them. - Matthew 18:20',
    'Come to me, all who labor and are heavy laden, and I will give you rest. - Matthew 11:28',
    'For nothing will be impossible with God. - Luke 1:37',
    'The Lord will fight for you, and you have only to be silent. - Exodus 14:14',
    'Blessed is the man who remains steadfast under trial, for when he has stood the test he will receive the crown of life. - James 1:12',
    'No temptation has overtaken you that is not common to man. God is faithful, and he will not let you be tempted beyond your ability. - 1 Corinthians 10:13',
    'The Lord bless you and keep you; the Lord make his face to shine upon you and be gracious to you. - Numbers 6:24-25',
    'Let us not grow weary of doing good, for in due season we will reap, if we do not give up. - Galatians 6:9',
    'But seek the welfare of the city where I have sent you into exile, and pray to the Lord on its behalf. - Jeremiah 29:7',
    'He heals the brokenhearted and binds up their wounds. - Psalm 147:3',
    'The Lord is near to all who call on him, to all who call on him in truth. - Psalm 145:18',
    'This is the day that the Lord has made; let us rejoice and be glad in it. - Psalm 118:24',
    'The Lord is good, a stronghold in the day of trouble; he knows those who take refuge in him. - Nahum 1:7',
    'For the wages of sin is death, but the gift of God is eternal life in Christ Jesus our Lord. - Romans 6:23',
    'Do not let your hearts be troubled. Trust in God; trust also in me. - John 14:1',
    'Peace I leave with you; my peace I give you. I do not give to you as the world gives. - John 14:27',
    'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God. - Philippians 4:6',
    'For it is by grace you have been saved, through faith—and this is not from yourselves, it is the gift of God. - Ephesians 2:8',
    'And we know that in all things God works for the good of those who love him, who have been called according to his purpose. - Romans 8:28',
    'For God did not send his Son into the world to condemn the world, but to save the world through him. - John 3:17',
    'The Lord your God is with you, the Mighty Warrior who saves. He will take great delight in you; in his love, he will no longer rebuke you, but will rejoice over you with singing. - Zephaniah 3:17',
    'Give thanks to the Lord, for he is good; his love endures forever. - 1 Chronicles 16:34',
    'But the Lord is faithful, and he will strengthen you and protect you from the evil one. - 2 Thessalonians 3:3',
    'When you pass through the waters, I will be with you; and through the rivers, they shall not overwhelm you. - Isaiah 43:2',
    'For God so loved the world, that he gave his only Son, that whoever believes in him should not perish but have eternal life. - John 3:16',
    'Finally, be strong in the Lord and in the strength of his might. - Ephesians 6:10',
    'The Lord is good, a refuge in times of trouble. He cares for those who trust in him. - Nahum 1:7',
    'The Lord is close to the brokenhearted and saves those who are crushed in spirit. - Psalm 34:18',
    'I will instruct you and teach you in the way you should go; I will counsel you with my loving eye on you. - Psalm 32:8',
    'The Lord is righteous in all his ways and faithful in all he does. - Psalm 145:17',
    'My grace is sufficient for you, for my power is made perfect in weakness. - 2 Corinthians 12:9',
    'The Lord gives strength to his people; the Lord blesses his people with peace. - Psalm 29:11',
    'We love because he first loved us. - 1 John 4:19',
    'Now faith is the assurance of things hoped for, the conviction of things not seen. - Hebrews 11:1',
    'If we confess our sins, he is faithful and just to forgive us our sins and to cleanse us from all unrighteousness. - 1 John 1:9',
    'Let the peace of Christ rule in your hearts, since as members of one body you were called to peace. - Colossians 3:15',
    'God is our refuge and strength, a very present help in trouble. - Psalm 46:1',
    'Be still, and know that I am God. - Psalm 46:10',
    'Come near to God and he will come near to you. - James 4:8',
    'Give thanks to the Lord, for he is good; his love endures forever. - Psalm 136:1',
    'The Lord will fight for you; you need only to be still. - Exodus 14:14',
  ];

  @override
  void initState() {
    super.initState();
    _loadDailyScripture();
  }

  // Function to load the daily scripture
  Future<void> _loadDailyScripture() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString('lastScriptureDate') ?? '';
    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastDate != now) {
      // If the current date is different, generate a new scripture and store it
      _generateRandomScripture();
      await prefs.setString('lastScriptureDate', now);
    } else {
      // Load the stored scripture
      setState(() {
        _currentScripture =
            prefs.getString('dailyScripture') ?? _scriptures.first;
      });
    }
  }

  // Function to generate a random scripture and store it
  Future<void> _generateRandomScripture() async {
    final random = Random();
    final newScripture = _scriptures[random.nextInt(_scriptures.length)];
    setState(() {
      _currentScripture = newScripture;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dailyScripture', newScripture);
  }

  void _shareScripture() {
    SharePlus.instance.share(ShareParams(text: _currentScripture));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Scripture of the Day',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: myMainColor),
            ),
            const SizedBox(height: 10),
            Text(
              _currentScripture,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: _shareScripture,
              child: const Text('Share Scripture'),
            ),
          ],
        ),
      ),
    );
  }
}
