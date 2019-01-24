import 'package:flutter/material.dart';
import 'beast_model.dart';
import 'dart:math';


class BeastPage extends StatefulWidget {
  final Beast beast;
  BeastPage({Key key, @required this.beast}) : super(key:key);

  @override
  BeastPageState createState() => new BeastPageState();
}
class BeastPageState extends State<BeastPage> {
  int vsAC = 15;
  int attack = 0;
  int health = 0;
  int damage = 0;
  int totDamage = 0;
  int beastCt = 0;
  String info = '';
  String damageInfo = '';
  String attack1 = '';
  String advantage = 'Straight';
  bool useAttack1 = false;
  void _change1(bool value) => setState(() => useAttack1 = value);
  bool useAttack2 = false;
  void _change2(bool value) => setState(() => useAttack2 = value);
  bool useAttack3 = false;
  void _change3(bool value) => setState(() => useAttack3 = value);
  bool useAttack4 = false;
  void _change4(bool value) => setState(() => useAttack4 = value);
  bool stopOnHit = false;
  void _toggleSoH(bool value) => setState(() => stopOnHit = value);
  bool contAtt = false;
  int start_i = 1;
  int start_k = 1;
  int start_ct = 0;

  @override initState(){
    super.initState();
    beastCt = widget.beast.count;
  }

  rollDice(int diceCt, int diceSize, int rollBonus, String adv) {
    // This function is the meat and potatoes of the dice rolling
    // it takes the number of dice, the dice size (i.e. 1d6), and adds the result to the rollBonus
    // If adv is 'Straight' then it is a straight roll, if 'Advantage' it will take the max of 2 d20s, etc.
    // Note that all damage rolls must be rolled as 'Straight'

    var sum = rollBonus;
    var rng = new Random();
    var rolls = [];
    var roll1 = 0;
    var roll2 = 0;
    String summary = '(';

    for (var i = 0; i < diceCt; i++) {
      // Rolls the dice twice
      roll1 = rng.nextInt(diceSize) + 1;
      roll2 = rng.nextInt(diceSize) + 1;

      if (adv == 'Advantage') { //Takes the max of roll1 and roll2
        rolls.add([roll1, roll2]);
        sum += [roll1, roll2].reduce(max);
      } else if (adv == 'Disadvantage') { //Takes the min of roll1 and roll2
        rolls.add([roll1, roll2]);
        sum += [roll1, roll2].reduce(min);
      } else { //Just takes roll1
        rolls.add(roll1);
        sum += roll1;
      }


    }
    for (var k = 0; k < rolls.length; k++) { //This is just to print to console for debugging
      summary += rolls[k].toString();
      k < rolls.length - 1 ? summary += " + " : summary += ")";
    }
    print("$diceCt d $diceSize + $rollBonus: $summary + $rollBonus = $sum"); //Debugging
    return sum;

  }

  toggleAdv() {
    setState(() {
      if (advantage == 'Straight') {
        advantage = 'Advantage';
      } else if (advantage == 'Advantage') {
        advantage = 'Disadvantage';
      } else {
        advantage = 'Straight';
      }
    });

  }

  /*setRowHeight(Beast b, int row) {
    var height = 20.0;
    if (b.attack1 != null && row == 1) {
      return height;
    } else if (b.attack2 != null && row == 2) {
      return height;
    } else if (b.attack3 != null && row == 3) {
      return height;
    } else if (b.attack4 != null && row == 4) {
      return height;
    } else {
      return 0.0;
    }
    }*/

    getBeastAttack(Beast b, int i){
      //None of the beasts have more than 4 attacks.  This will make sure non-existent attacks are not shown
      switch(i) {
        case 1:{return b.attack1 == null ? '' : b.attack1 + ":";}
          break;
        case 2:{return b.attack2 == null ? '' : b.attack2 + ":";}
          break;
        case 3:{return b.attack3 == null ? '' : b.attack3 + ":";}
          break;
        case 4:{return b.attack4 == null ? '' : b.attack4 + ":";}
          break;
      }
    }

    returnCheckbox(Beast b, int i) {
      //As with previous function, this ensure the non-existent attacks are not shown
      switch(i) {
        case 1:{return b.attack1 == null ? Text('') : Checkbox(value: useAttack1, onChanged: _change1);}
          break;
        case 2:{return b.attack2 == null ? Text('') : Checkbox(value: useAttack2, onChanged: _change2);}
          break;
        case 3:{return b.attack3 == null ? Text('') : Checkbox(value: useAttack3, onChanged: _change3);}
          break;
        case 4:{return b.attack4 == null ? Text('') : Checkbox(value: useAttack4, onChanged: _change4);}
          break;
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beast.bType),
      ),

      body: Padding(
        padding: new EdgeInsets.all(10.0),
        child:Column(
          children: <Widget>[
            Row(
              children: <Widget> [
                Text(widget.beast.bType + " Count: ", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0)),
                SizedBox(
                  width:40.0,
                  child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          if (beastCt > 0) {
                            beastCt -= 1;
                          }
                        });
                      },
                      child: Text("-", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0))
                    ),
                ),
                Text("  $beastCt  ", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0)),
                SizedBox(
                  width:40.0,
                  child:RaisedButton(
                    onPressed: () {
                      setState(() {
                        beastCt += 1;
                      });
                    },
                  child: Text("+", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0))
                ),
                ),
              ]
            ),
            Row(
              children: <Widget> [
                SizedBox(
                  width:110.0,
                  height:30.0,
                  child: RaisedButton(
                    color: Colors.greenAccent,
                    onPressed: () {
                      setState(() {
                        info = '---Rolling Hitpoints---';

                        for (var i=1; i < beastCt + 1; i++) {
                          info += "\n " + widget.beast.bType + " #" + i.toString() + ": " + rollDice(widget.beast.hitDiceCt,widget.beast.hitDiceSize,widget.beast.hitDiceBonus + 2*widget.beast.hitDiceCt,'Straight').toString();
                        }
                      });
                    },
                    child: Text("Roll Hit Dice")
                  )
                ),
                Text("    " + widget.beast.hitDiceCt.toString() + "d" + widget.beast.hitDiceSize.toString() + "+" + (widget.beast.hitDiceBonus + 2 * widget.beast.hitDiceCt).toString() + "           "),
                SizedBox(
                  width:70.0,
                  height:30.0,
                  child: RaisedButton(
                    padding: const EdgeInsets.all(0.0),
                    color: Colors.greenAccent,
                    onPressed: () {
                      setState(() {
                        bool breakFor;
                        int ct = start_ct;
                        if (!contAtt) {
                          info = '';
                          totDamage = 0;
                        }

                        outerLoop: // This loop goes through all the beasts set in the count and all of the attacks chosen
                        for (var i=start_i; i < beastCt + 1; i++) {
                          for (var k = start_k; k < 5; k++) {
                            contAtt = true;
                            breakFor = false;
                            print(i.toString() + " - " + k.toString());
                            bool attBool;
                            String attType;
                            int attB;
                            int damDct1;
                            int damDsz1;
                            int damBon1;
                            /*int damDct2;
                            int damDsz2;
                            int damBon2;*/

                            switch (k){
                              case 1: {
                                attBool = useAttack1;
                                attType = widget.beast.attack1;
                                attB = widget.beast.attBonus1;
                                damDct1 = widget.beast.damDiceCt1;
                                damDsz1 = widget.beast.damDiceSize1;
                                damBon1 = widget.beast.damBonus1;
                              }
                              break;
                              case 2: {
                                attBool = useAttack2;
                                attType = widget.beast.attack2;
                                attB = widget.beast.attBonus2;
                                damDct1 = widget.beast.damDiceCt2;
                                damDsz1 = widget.beast.damDiceSize2;
                                damBon1 = widget.beast.damBonus2;
                              }
                              break;
                              case 3: {
                                attBool = useAttack3;
                                attType = widget.beast.attack3;
                                attB = widget.beast.attBonus3;
                                damDct1 = widget.beast.damDiceCt3;
                                damDsz1 = widget.beast.damDiceSize3;
                                damBon1 = widget.beast.damBonus3;
                              }
                              break;
                              case 4: {
                                attBool = useAttack4;
                                attType = widget.beast.attack4;
                                attB = widget.beast.attBonus4;
                                damDct1 = widget.beast.damDiceCt4;
                                damDsz1 = widget.beast.damDiceSize4;
                                damBon1 = widget.beast.damBonus4;
                              }
                              break;
                            }

                            if (attBool) {
                              attack = rollDice(1, 20, attB, advantage);
                              ct +=1;
                              info += "$attType #$i: $attack";
                              if (attack == attB + 20) {
                                damage = rollDice(damDct1 * 2, damDsz1, damBon1, 'Straight');
                                totDamage += damage;
                                info += " CRIT!";
                                info += "  Dam: $damage";
                                if (stopOnHit) {
                                  if (k<4) {
                                    start_i = i;
                                    start_k = k + 1;
                                  } else if (i < beastCt){
                                    start_i = i + 1;
                                    start_k = 1;
                                  } else {
                                    start_i = 1;
                                    start_k = 1;
                                  }
                                  start_ct = ct;
                                  breakFor = true;
                                  break outerLoop;
                                }
                              } else if (attack >= vsAC) {
                                damage = rollDice(damDct1, damDsz1, damBon1, 'Straight');
                                totDamage += damage;
                                info += " HIT!";
                                info += "  Dam: $damage";
                                if (stopOnHit) {
                                  if (k<4) {
                                    start_i = i;
                                    start_k = k + 1;
                                  } else if (i < beastCt){
                                    start_i = i + 1;
                                    start_k = 1;
                                  } else {
                                    start_i = 1;
                                    start_k = 1;
                                  }
                                  start_ct = ct;
                                  breakFor = true;
                                  break outerLoop;
                                }
                              } else {
                                info += " MISS!  ";
                              }
                              ct % 2 == 0 ? info += " \n" : info += "  -  ";
                            }
                          }
                          start_k = 1;
                        }

                        if( !breakFor ) {
                          start_i = 1;
                          start_k = 1;
                          contAtt = false;
                          start_ct = 0;
                        } else {
                          ct % 2 == 0 ? info += " \n" : info += "  -  ";
                        }

                        damageInfo = "   Total Damage: $totDamage";
                      });
                    },
                    child: Text("Attack", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0))
                  ),
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:5.0),
                  child: Text(widget.beast.info, style: TextStyle(fontSize: 12.0))
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                Container(//attack1
                  child: Row(
                    children: <Widget> [
                      SizedBox(
                        child: Text(getBeastAttack(widget.beast, 1), style: TextStyle(fontSize: 16.0)),
                      ),
                      returnCheckbox(widget.beast,1),
                    ]
                  )
                ),
                Container(//attack2
                  child: Row(
                    children: <Widget> [
                      SizedBox(
                        child: Text(getBeastAttack(widget.beast, 2), style: TextStyle(fontSize: 16.0)),
                      ),
                      returnCheckbox(widget.beast,2),
                    ]
                  )
                ),
                Container(//attack3
                  child: Row(
                    children: <Widget> [
                      SizedBox(
                          child: Text(getBeastAttack(widget.beast, 3), style: TextStyle(fontSize: 16.0)),
                      ),
                      returnCheckbox(widget.beast,3),
                    ]
                  )
                ),
                Container(//attack4
                  child: Row(
                    children: <Widget> [
                      SizedBox(
                          child: Text(getBeastAttack(widget.beast, 4), style: TextStyle(fontSize: 16.0)),
                      ),
                      returnCheckbox(widget.beast,4),
                    ]
                  )
                )

              ]
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                Text("SoH:"),
                Checkbox(value: stopOnHit, onChanged: _toggleSoH),
                Text("AC: "),
                SizedBox(
                  width:30.0,
                  height:30.0,
                  child: RaisedButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      setState(() {
                        if (vsAC > 0) {
                          vsAC -= 1;
                        }
                      });
                    },
                    child: Text("-", style: TextStyle(fontSize: 12.0))
                  ),
                ),
                Text(" $vsAC ", style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16.0)),
                SizedBox(
                  width:30.0,
                  height:30.0,
                  child:RaisedButton(
                    padding: const EdgeInsets.all(0.0),
                    onPressed: () {
                      setState(() {
                        vsAC += 1;
                      });
                    },
                    child: Text("+", style: TextStyle(fontSize: 12.0))
                  ),
                ),
                Text("    "),
                RaisedButton(
                  onPressed: () {
                    toggleAdv();
                  },
                  child: Text("$advantage")
                )
              ]
            ),

            Container(
              margin: EdgeInsets.only(top:10.0),
              child: Column(
                children: <Widget>[
                  Text("Summary of Events:" + damageInfo),
                  Text(" ", style: TextStyle(fontSize:10.0)),
                  Text(info, style: TextStyle(fontSize:10.0))
                ]
              )
            )
          ]
        ),
      ),
    );
  }



}


