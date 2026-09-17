package lord

import (
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"maps"
)

// ErrStaleSave is a saved game that cannot be resumed: another model's, or one
// with a move that no longer plays.
var ErrStaleSave = errors.New("the saved game cannot be resumed")

// Save is a game as the record that replays it: the model it was played against,
// its dice, the character and every move since, in order.
type Save struct {
	Model     string    `json:"model"`
	Seed      uint64    `json:"seed"`
	Character Character `json:"character"`
	Moves     []Move    `json:"moves"`
}

// Move is one play: the key pressed and the inputs its choice asked for.
type Move struct {
	Key    string            `json:"key"`
	Inputs map[string]string `json:"inputs,omitempty"`
}

// ModelDigest names a model's source, so a save tells which model it belongs to.
func ModelDigest(modelSource []byte) string {
	sum := sha256.Sum256(modelSource)
	return hex.EncodeToString(sum[:])
}

// Save records the game as played so far: what Resume needs to reach this state again.
func (g *Game) Save() *Save {
	moves := make([]Move, len(g.moves))
	for i, m := range g.moves {
		moves[i] = Move{Key: m.Key, Inputs: maps.Clone(m.Inputs)}
	}
	return &Save{Model: ModelDigest(g.source), Seed: g.seed, Character: g.character, Moves: moves}
}

// Resume plays a saved game again: a new game with its seed and character, its
// moves replayed. Another model's save, or one whose move no longer plays, is ErrStaleSave.
func Resume(modelSource []byte, save *Save) (*Game, error) {
	if save == nil {
		return nil, fmt.Errorf("%w: there is no save", ErrStaleSave)
	}
	if save.Model != ModelDigest(modelSource) {
		return nil, fmt.Errorf("%w: it was played against another model", ErrStaleSave)
	}
	g, err := NewGame(modelSource, save.Seed, save.Character)
	if err != nil {
		return nil, err
	}
	for i, move := range save.Moves {
		if _, err := g.Play(move.Key, move.Inputs); err != nil {
			_ = g.Close()
			return nil, fmt.Errorf("%w: move %d (%s): %v", ErrStaleSave, i+1, move.Key, err)
		}
	}
	return g, nil
}
