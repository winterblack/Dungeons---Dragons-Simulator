module Spellcaster
    attr_accessor :spell_slots

    SpellSlotsByLevel = [
        [      :level, 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
        [:spell_slots, 2                         ],
        [:spell_slots, 3                         ],
        [:spell_slots, 4, 2                      ],
        [:spell_slots, 4, 3                      ],
        [:spell_slots, 4, 3, 2                   ],
        [:spell_slots, 4, 3, 3                   ],
        [:spell_slots, 4, 3, 3, 1                ],
        [:spell_slots, 4, 3, 3, 2                ],
        [:spell_slots, 4, 3, 3, 3, 1             ],
        [:spell_slots, 4, 3, 3, 3, 2             ],
        [:spell_slots, 4, 3, 3, 3, 2, 1          ],
        [:spell_slots, 4, 3, 3, 3, 2, 1          ],
        [:spell_slots, 4, 3, 3, 3, 2, 1, 1       ],
        [:spell_slots, 4, 3, 3, 3, 2, 1, 1       ],
        [:spell_slots, 4, 3, 3, 3, 2, 1, 1, 1    ],
        [:spell_slots, 4, 3, 3, 3, 2, 1, 1, 1    ],
        [:spell_slots, 4, 3, 3, 3, 2, 1, 1, 1, 1 ],
        [:spell_slots, 4, 3, 3, 3, 3, 1, 1, 1, 1 ],
        [:spell_slots, 4, 3, 3, 3, 3, 2, 1, 1, 1 ],
        [:spell_slots, 4, 3, 3, 3, 3, 2, 2, 1, 1 ]
      ]

    def initialize character
        super character
        set_spell_slots
    end

    def set_spell_slots
        @spell_slots = SpellSlotsByLevel[level].dup
    end
end
