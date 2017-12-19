import React from 'react';
import PropTypes from 'prop-types';
import wp from 'wp';

import PostSelectModal from './modal';

const {
	Button,
} = wp.components;

const { __ } = wp.i18n;

class PostSelectButton extends React.Component {
	state = {
		modalVisible: false,
		posts: [],
	}

	render(){
		const {
			children,
			onSelect,
		} = this.props;

		const { modalVisible } = this.state;

		const onClose = () => this.setState( { modalVisible: false } );

		return <div className="post-select">
			<Button
				isLarge={true}
				onClick={ () => this.setState( { modalVisible: true } ) }
			>{ children }</Button>
			{ modalVisible && (
				ReactDOM.createPortal(
					<PostSelectModal
						{ ...this.props }
						onSelect={ posts => {
							onSelect( posts );
							onClose();
						} }
						onClose={ onClose }
					/>,
					document.getElementById('wpbody')
				)
			) }
		</div>
	}
}

PostSelectButton.propTypes = {
	btnText: PropTypes.string,
	onSelect: PropTypes.func.isRequired,
}

export default PostSelectButton;
