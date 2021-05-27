# Esperanto

[![Coverage Status](https://coveralls.io/repos/github/betrybe/esperanto/badge.svg?t=FTzZtC)](https://coveralls.io/github/betrybe/esperanto)
![GitHub branch checks state](https://img.shields.io/github/checks-status/betrybe/esperanto/main)


### Esperanto Olx

Esperanto extends the markdown and add support for the [Open Learning XML](https://edx.readthedocs.io/projects/edx-open-learning-xml/en/latest/). For now the only [multiple choice problem](https://edx.readthedocs.io/projects/edx-open-learning-xml/en/latest/problem-xml/multiple_choice.html) is supported.  

The sintax is very simple, and we have a few examples inside the `esperanto/apps/olx/test/fixtures/quiz-145-11-1` with examples of the markdown and the expected xml. Also we have a model inside `apps/olx/modelo/quiz/01.mdx`.  

Current mardowns tags supported are: 
 * *italic*
 * **bold**
 * `inline code`
 * ```
    code bloc
   ```
 * image using `![alt](http://image.file.jpg)`
 * And links `[link title](http://example.com)`
   

Ex:

the following markdown:

```
>>Which of the following is an example of a vegetable?

( ) apple {{An apple is the fertilized ovary that comes from an apple tree
and contains seeds classifying it as a fruit.}}
( ) pumpkin {{A pumpkin is the fertilized ovary of a squash plant and
contains seeds classifying it as a fruit.}}
(x) potato {{A potato is an edible part of a plant in tuber form and is
classified as a vegetable}}
( ) tomato {{Many people mistakenly think a tomato is a vegetable. However,
because a tomato is the fertilized ovary of a tomato plant and contains
seeds it is classified as a fruit.}}
```

generate the following xml:

```
<problem>
  <multiplechoiceresponse>
    <label>Which of the following is an example of a vegetable?</label>
    <choicegroup type="MultipleChoice">
      <choice correct="false">apple
        <choicehint>An apple is the fertilized ovary that comes from an apple
         tree and contains seeds classifying it as a fruit.</choicehint>
      </choice>
      <choice correct="false">pumpkin
        <choicehint>A pumpkin is the fertilized ovary of a squash plant
         and contains seeds classifying it as a fruit.</choicehint>
      </choice>
      <choice correct="true">potato
        <choicehint>A potato is an edible part of a plant in tuber form and
         is classified as a vegetable.</choicehint>
      </choice>
      <choice correct="false">tomato
        <choicehint>Many people mistakenly think a tomato is a vegetable.
         However, because a tomato is the fertilized ovary of a tomato plant
         and contains seeds it is classified as a fruit.</choicehint>
      </choice>
    </choicegroup>
  </multiplechoiceresponse>
</problem>
```

